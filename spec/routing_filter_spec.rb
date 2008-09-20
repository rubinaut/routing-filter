require File.dirname(__FILE__) + '/helper/spec_helper.rb'

describe 'RoutingFilter' do
  include RoutingFilterHelpers

  before :each do
    @controller = instantiate_controller :locale => 'de', :section_id => 1
    @set = draw_routes do |map|
      map.section 'sections/:section_id', :controller => 'sections', :action => "show"
      map.filter 'locale'
      map.filter 'mock'
    end
    @locale_filter = @set.filters.first
    @mock_filter = @set.filters.last
  end
  
  def recognize_path(path = '/de/sections/1', options = {})
    @set.recognize_path path, options
  end
  
  def generate_url_for(options = {:controller => 'sections', :action => 'show', :section_id => 1})
    @controller.send :url_for, options
  end

  it 'installs filters to the route set' do
    @locale_filter.should be_instance_of(RoutingFilter::Locale)
    @mock_filter.should be_instance_of(RoutingFilter::Mock)
  end

  it 'calls the first filter for route recognition' do
    @locale_filter.should_receive :around_recognition
    recognize_path
  end

  it 'calls the second filter for route recognition' do
    @mock_filter.should_receive :around_recognition
    recognize_path
  end

  it 'calls the first filter for url generation' do
    @locale_filter.should_receive :around_generation
    generate_url_for
  end

  it 'calls the second filter for url generation' do
    @mock_filter.should_receive :around_generation
    generate_url_for
  end

  it 'calls the first filter for named route url_helper' do
    @locale_filter.should_receive :around_generation
    @controller.send :section_path, :section_id => 1
  end
  
  it 'calls the filter for named route url_helper with "optimized" generation blocks' do
    @locale_filter.should_receive :around_generation
    @controller.send :section_path, 1
  end
  
  it 'calls the filter for named route polymorphic_path' do
    @locale_filter.should_receive :around_generation
    @controller.send :section_path, Section.new
  end
end