require 'rails_helper'

describe "Home Controller" do

  it "renders a 200 for a request" do
    get home_index_path
    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
  end

  it 'takes record of a successful request' do
    expect(Request.count).to eq(0)
    get home_index_path
    expect(Request.count).to eq(1)
  end

  context 'hitting the rate limit' do
    let!(:requests) do
      (1..99).each { |number| Request.add('127.0.0.1', requested_at: number.seconds.ago )}
    end

    it 'renders a 429 if the rate limit threshold has been hit' do
      get home_index_path
      expect(response.status).to eq(200)
      expect(response.body).to eq("ok")
      get home_index_path
      expect(response.status).to eq(429)
      expect(response.body).to include("Rate limit exceeded, please try again")
    end

  end
end
