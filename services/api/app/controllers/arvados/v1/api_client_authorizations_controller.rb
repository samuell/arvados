class Arvados::V1::ApiClientAuthorizationsController < ApplicationController
  before_filter :current_api_client_is_trusted

  protected

  def find_objects_for_index
    # Here we are deliberately less helpful about searching for client
    # authorizations. Rather than use the generic index/where/order
    # featuers, we look up tokens belonging to the current user and
    # filter by exact match on api_token (which we expect in the form
    # of a where[uuid] parameter to make things easier for API client
    # libraries).
    @objects = model_class.
      includes(:user, :api_client).
      where('user_id=? and (? or api_token=?)', current_user.id, !@where['uuid'], @where['uuid']).
      order('created_at desc')
  end

  def find_object_by_uuid
    # Again, to make things easier for the client and our own routing,
    # here we look for the api_token key in a "uuid" (POST) or "id"
    # (GET) parameter.
    @object = model_class.where('api_token=?', params[:uuid] || params[:id]).first
  end

  def current_api_client_is_trusted
    unless Thread.current[:api_client].andand.is_trusted
      render :json => { errors: ['Forbidden: this API client cannot manipulate other clients\' access tokens.'] }.to_json, status: 403
    end
  end
end