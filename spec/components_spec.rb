require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Chargify::Component do
  describe "Recording usage" do
    before(:each) do
      @subscription = Factory(:subscription)
      @component = Factory(:component)
      @now = DateTime.now.to_s
    end
    
    it "should create a usage record" do
      u = Chargify::Usage.new
      u.subscription_id = @subscription.id
      u.component_id = @component.id
      u.quantity = 5
      u.memo = @now
      u.save
      
      component = Chargify::Usage.find(:last, :params => {:subscription_id => @subscription.id, :component_id => @component.id})
      component.memo.should == @now
      component.quantity.should == 5
    end
    
    it "should allow you to pass all args to the initializer" do
      u = Chargify::Usage.new(:subscription_id => 4, :component_id => 5, :quantity => 5, :memo => @now)
      u.save
      
      component = Chargify::Usage.find(:last, :params => {:subscription_id => 4, :component_id => 5})
      component.memo.should == @now
      component.quantity.should == 5
    end
    
    it "should also take Chargify::Component & Chargify::Subscription objects" do
      @component.id = 4
      @subscription.id = 5
      u = Chargify::Usage.new(:subscription => @subscription, :component => @component, :quantity => 4, :memo => @now)
      u.save
      
      component = Chargify::Usage.find(:last, :params => {:subscription_id => @subscription.id, :component_id => @component.id})
      component.memo.should == @now
      component.quantity.should == 4
    end
  end
  
  describe "Listing usages" do
    before do
      @subscription = Factory(:subscription)
      @component = Factory(:component)
      @now = DateTime.now.to_s
      create_usage
    end
    
    it "should return all usages for a component and subscription" do
      component = Chargify::Usage.find(:last, :params => {:subscription_id => @subscription.id, :component_id => @component.id})
      component.quantity.should == 5
    end
  end
  
  def create_usage
    u = Chargify::Usage.new
    u.subscription_id = @subscription.id
    u.component_id = @component.id
    u.quantity = 5
    u.memo = @now
    u.save
  end
end
  