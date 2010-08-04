require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Bell
  describe UserHandler do
    let(:args) { mock("args") }
    let(:user_handler) { UserHandler.new(args) }

    describe "#valid_args?" do
      context "when no additional arguments are passed" do
        it "returns true" do
          args.stub!(:length).and_return(1)
          user_handler.valid_args?.should be_true
        end
      end

      context "when invalid additional arguments are passed" do
        it "returns false" do
          args.stub!(:length).and_return(2)
          args.stub!('[]').with(1).and_return("blabla")
          user_handler.valid_args?.should be_false
        end
      end

      context "when valid additional arguments are passed" do
        it "returns true" do
          args.stub!(:length).and_return(2)
          args.stub!('[]').with(1).and_return("create")
          user_handler.valid_args?.should be_true
        end
      end
    end
  end
end
