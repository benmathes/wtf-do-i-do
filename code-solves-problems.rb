require 'pp'

# based on principles from http://www.ted.com/talks/sheena_iyengar_choosing_what_to_choose.html
# 1) cut (down to 4)
# 2) concretize (see "gut" and "personal reaction to photos of offices, location")
# 3) categorize
# 4) condition: start with fewer choices in multi-dimensional approach 
#    (order I filled out categories is top-> bottom, or fewer criteria -> more criteria)

# note that these are NOT absolute ratings on companies, 
# just my sense on personal fit.


# qualitative_scores: when GIGO is a problem you need to remove choice and only
# allow a few ratings: remove paradox of choice (i.e. 8/10? 9/10? 8.5/10?),
# think of it as forcing me to shit or get off the pot.
qs = {
  'a' => 6, # absolutely
  'y' => 4, # yes
  'm' => 2, # maybe
  'w' => 1 # worrisome
}

# and you need to categorize. focusing down helps you evaluate better.
category_weights = {
  'daily life' => 'y',
  'gut' => 'm',
  'culture' => 'y',
  'comp' => 'y',
  'meta-goals' => 'y',
  'potential' => 'y',
}

# category => criteria => qualitative rating for [ euclid, angellist ]
categories = {
  'gut' => {
    'looking at campus photos' => %w{y y},
    'looking at personell photos' => %w{y m},
    'want to go to work tomorrow' => %w{y m}
  },
  'meta-goals' => {
    'living in SF' => %w{y a},
    'living young while young' => %w{y a},
    'build network' => %w{m y},
    'want to be like founder(s)?' => %w{m m},
    'want to be like coworkers?' => %w{y m},
  },
  'comp' => {
    'salary' => %w{a m},
    'potential cashout' => %w{y m},
    'perks' => %w{y y},
    'location' => %w{m y}
  },
  'potential' => {
    'founders' => %w{y y},
    'no fail' => %w{y m},
    'realistic market impact' => %w{y m},
    'cool factor' => %w{m y},
    'celebrity' => %w{m a},
    'overall uncertainty' => %w{y y}
  },
  'culture' => {
    'coworkers as friends' => %w{y m},
    'coworkers as contacts' => %w{m y},
    'shared values / importance of data' => %w{a a},
    'no sleaze' => %w{y m},
    'teaching/learning' => %w{y m},
    'well rounded eng' => %w{a m},
    'work/life balance' => %w{y m},
    'remote work / flexibility' => %w{m a},
    'wildcards' => %w{y y},
  },
  'daily life' => {
    'leadership role' => %w{y y},
    'tech abilities of coworkers' => %w{y y},
    'tools' => %w{y y},
    'product' => %w{y y},
    'mentor potential' => %w{y y},
    'proj/tech design freedom' => %w{y a},
    'learn from who work with' => %w{y y},
    'lifestyle wildcard' => %w{y m},
  }
}


# category => criterion => [ lytro, euclid, angellist, sincerely ]
overall = {}
numCriteria = 0
categories.each do |category, criteria|
  this_cat = [0.0, 0.0]
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
  puts "   euclid:    #{ratings[0]}"
  puts "   angellist: #{ratings[1]}"
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

puts("----------------------------------")
puts("avg, weighted by category:")
puts("   euclid:    #{weighted_avg[0]}")
puts("   angellist: #{weighted_avg[1]}")


