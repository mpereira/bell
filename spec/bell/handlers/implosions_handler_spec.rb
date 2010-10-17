require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Handlers::ImplosionsHandler do
  let(:params) { mock("params").as_null_object }
  let(:implosions_handler) { described_class }

  it "implodes the current bell databases" do
    Bell.should_receive(:implode!)
    implosions_handler.implode(params)
  end
end
