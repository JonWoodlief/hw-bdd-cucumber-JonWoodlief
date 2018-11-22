# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.index(e1).should < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I uncheck the following ratings: (.*)/ do |rating_list|
    ratings = rating_list.scan(/(?<=')\S(?=')/)
    ratings.each do |rating|
        uncheck("ratings_#{rating}")
    end
end
    
When /I check the following ratings: (.*)/ do |rating_list|
    ratings = rating_list.scan(/(?<=')\S+(?=')/)
    ratings.each do |rating|
        check("ratings_#{rating}")
    end
end

Then /I should see all movies/ do
    page.all('table#movies tr').count.should == 11
end

When(/^I press: submit$/) do
    click_button("ratings_submit")
end

Then(/^I should see: (.*)/) do |rating_list|
    ratings = rating_list.scan(/(?<=')\S+(?=')/)
    
    
    ratings.each do |rating|
        page.has_checked_field?('ratings_#{rating}')
    end
end

Then(/^I should not see: (.*)/) do |rating_list|
    ratings = rating_list.scan(/(?<=')\S+(?=')/)
    ratings.each do |rating|
        page.has_unchecked_field?('ratings_#{rating}')
    end
end