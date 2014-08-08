# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unavailable_time, :class => 'UnavailableTimes' do
    start_time "2014-08-08 12:10:34"
    end_time "2014-08-08 12:10:34"
    user nil
  end
end
