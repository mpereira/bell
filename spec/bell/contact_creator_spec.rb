require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactCreator do
  let(:messenger) { mock("messenger") }
  let(:contact_creator) { described_class.new(messenger) }
end
