require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Bell
  describe UserHandler do
    let(:args) { mock("args").as_null_object }
    let(:user_handler) { UserHandler.new(args) }
    let(:actions) { user_handler.actions }

    describe "#valid_action?" do
      context "when given a valid action" do
        it "returns true" do
          args.stub!('[]').with(1).and_return('create')
          actions.stub!(:include?).with(args).and_return(true)
          user_handler.valid_action?.should be_true
        end
      end

      context "when given an invalid action" do
        it "returns false" do
          args.stub!('[]').with(1).and_return('foo')
          actions.stub!(:include?).with(args).and_return(false)
          user_handler.valid_action?.should be_false
        end
      end
    end
  end
end
