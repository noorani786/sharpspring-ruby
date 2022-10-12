require 'rest-client'
require 'json'
require 'jsonpath'

class Sharpspring
  attr_accessor :has_more, :processor

  GET_OBJECT_METHOD = {
    'lead' => 'getLeads',
    'campaign' => 'getCampaigns',
    'account' => 'getAccounts',
    'opportunity' => 'getOpportunities',
    'dealStage' => 'getDealStages'
  }

  GET_OBJECT_DATE_RANGE_METHOD = {
    'lead' => 'getLeadsDateRange',
    'opportunity' => 'getOpportunitiesDateRange',
  }

  CREATE_OBJECT_METHOD = {
    'lead' => 'createLeads',
    'campaign' => 'createCampaigns',
    'account' => 'createAccounts',
    'opportunity' => 'createOpportunities'
  }

  UPDATE_OBJECT_METHOD = {
    'lead' => 'updateLeads',
  }

  DELETE_OBJECT_METHOD = {
    'lead' => 'deleteLeads',
  }

  def initialize(account_id, secret_key)
    @post_uri = "https://api.sharpspring.com/pubapi/v1?accountID=#{account_id}&secretKey=#{secret_key}"
  end

  def cleanup
    @has_more = false
  end

  def get_objects(object_name, page, where = {})
    api_method = GET_OBJECT_METHOD[object_name]
    limit = 200 # 500 fails
    params = {
      where: where,
      limit: limit,
      offset: limit * page
    }
    return_field = object_name
    response = make_api_call(api_method, params)
    result = JsonPath.on(response, "$.result.#{return_field}[:]")
    @has_more = result.count == limit
    return result
  end

  def get_objects_date_range(object_name, start_date, end_date, page)
    start_date = start_date.strftime("%Y-%m-%d %H:%M:%S")
    end_date = end_date.strftime("%Y-%m-%d %H:%M:%S")

    api_method = GET_OBJECT_DATE_RANGE_METHOD[object_name]
    params = {
      startDate: start_date,
      endDate: end_date,
      timestamp: 'update'
    }
    return_field = object_name
    response = make_api_call(api_method, params)
    result = JsonPath.on(response, "$.result.#{return_field}[:]")
    @has_more = false # sharpspring does not expose limit/offset for these queries
    return result
  end

  def create_objects(object_name, objects)
    api_method = CREATE_OBJECT_METHOD[object_name]
    params = format_crd_params(objects)
    response = make_api_call(api_method, params)
    format_crd_response('creates', response, objects)
  end

  def update_objects(object_name, objects)
    api_method = UPDATE_OBJECT_METHOD[object_name]
    params = format_crd_params(objects)
    response = make_api_call(api_method, params)
    format_crd_response('updates', response, objects)
  end

  def delete_objects(object_name, objects)
    api_method = DELETE_OBJECT_METHOD[object_name]
    params = format_crd_params(objects)
    response = make_api_call(api_method, params)
    format_crd_response('deletes', response, objects)
  end

  def cleanup
  end

  def format_crd_params(objects)
    { 'objects' => objects }
  end

  def format_crd_response(method, response, objects)
    response.dig('result', method)
  end

  def make_api_call(method, params)
    request_id = (0...20).map { ('a'..'z').to_a[rand(26)] }.join
    data = {
      method: method,
      params: params,
      id: request_id
    }.to_json

    puts data

    response = RestClient.post @post_uri, data, :content_type => :json, :accept => :json

    puts response.to_str

    JSON.parse(response.to_str)
  end
end
