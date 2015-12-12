require 'rails_helper'

RSpec.describe 'routing to user api' do
  it 'routes /api/v1/users to api/v1/users#index' do
    expect(get: '/api/v1/users').to route_to(
      controller: 'api/v1/users',
      action: 'index',
      format: 'json'
    )
  end
end
