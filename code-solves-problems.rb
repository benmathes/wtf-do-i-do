require 'pp'

# based on principles from http://www.ted.com/talks/sheena_iyengar_choosing_what_to_choose.html
# 1) cut (down to 4)
# 2) concretize (see "gut" and "personal reaction to photos of offices, location")
# 3) categorize
# 4) condition: start with fewer choices in multi-dimensional approach 
#    (order I filled out categories is top-> bottom, or fewer criteria -> more criteria)

# note that these are NOT absolute ratings on companies, 
# just my sense on how me and the company fit.


# qualitative_scores: when GIGO is a problem you need to remove choice and only
# allow a few ratings: remove paradox of choice (i.e. 8/10? 9/10? 8.5/10?),
# think of it as forcing me to shit or get off the pot.
qs = {
  'a' => 4, # absolutely
  'y' => 2, # yes
  'm' => 1, # maybe
  'w' => -1 # worrisome
}

# and you need to categorize. focusing down helps you evaluate better.
category_weights = {
  'culture' => 'y',
  'comp' => 'm',
  'daily life' => 'a',
  'potential' => 'y',
  'gut' => 'y'
}

# category => criteria => qualitative rating for [ lytro, euclid, angellist, sincerely ]
categories = {
  'gut' => {
    'looking at campus photos' => %w{w y y y},
    'looking at personell photos' => %w{m y m y},
  },
  'comp' => {
    'salary' => %w{y y m y},
    'potential cashout' => %w{a y m m},
    'perks' => %w{m y a a},
    'location' => %w{w m y y}
  },
  'potential' => {
    'founders' => %w{y y m y},
    'no fail' => %w{a y m m},
    'realistic market impact' => %w{y y m m},
    'cool factor' => %w{y m y y},
    'celebrity' => %w{y m y y},
    'overall uncertainty' => %w{m y y m}
  },
  'culture' => {
    'coworkers as friends' => %w{m y m a},
    'coworkers as contacts' => %w{y m y y},
    'shared values / importance of data' => %w{m a a a},
    'no sleaze' => %w{a y m m},
    'teaching/learning' => %w{y y y m},
    'well rounded eng' => %w{m a m y},
    'work/life balance' => %w{a y m m},
    'remote work / flexibility' => %w{y m a w},
  },
  'daily life' => {
    'leadership role' => %w{m y y a},
    'tech abilities of coworkers' => %w{m y y m},
    'tools' => %w{m y y m},
    'product' => %w{a y y m},
    'mentor potential' => %w{y y y y},
    'proj/tech design freedom' => %w{m y a m},
    'learn from who work with' => %w{w y y m},
    'lifestyle wildcard' => %w{w y m y},
  }
}


# category => criterion => [ lytro, euclid, angellist, sincerely ]
overall = {}
numCriteria = 0
categories.each do |category, criteria|

  this_cat = [0.0, 0.0, 0.0, 0.0]
  criteria.each do |criterion, ratings|
    ratings.each_index do |i|
      this_cat[i] += qs[ratings[i]]
    end
  end

  # avg per category, rounding to tenths
  this_cat.each_index do |i|
    this_cat[i] = ((this_cat[i]/criteria.size)*10).ceil/10.0
  end

  overall[category] = this_cat
end

overall.each do |category, ratings|
  puts "#{category}: #{category_weights[category]}, scaled by factor of #{qs[category_weights[category]]}"
  puts "   lytro:     #{ratings[0]}"
  puts "   euclid:    #{ratings[1]}"
  puts "   angellist: #{ratings[2]}"
  puts "   sincerely: #{ratings[3]}"
end
  
# weight based on category
weighted_sum = [0.0, 0.0, 0.0, 0.0]
overall.each do |category, ratings|
  ratings.each_index do |i|
    weighted_sum[i] += (qs[category_weights[category]] * ratings[i])
  end
end

# avg by category
weighted_avg = weighted_sum
weighted_avg.each_index do |i|
  weighted_avg[i] = ( ( weighted_avg[i] / categories.size ) * 10 ).ceil/10.0
end

puts "\navg, weighted by category:"
puts "   lytro:     #{weighted_avg[0]}"
puts "   euclid:    #{weighted_avg[1]}"
puts "   angellist: #{weighted_avg[2]}"
puts "   sincerely: #{weighted_avg[3]}"


