require 'rails_helper'

describe "Home Controller" do

  it "renders a 200 for a request" do
    get home_index_path
    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
  end

  it 'renders a 429 if the rate limit threshold has been hit'

  
end