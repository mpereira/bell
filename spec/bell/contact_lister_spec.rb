require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactLister do
  let(:messenger) { mock("messenger").as_null_object }
  let(:contact_lister) { described_class.new(messenger) }
end
