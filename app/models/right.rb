class Right < ActiveRecord::Base

  # enum accessible: {everyone: 0, myself: 1}
  ACCESSIBLE = [{"right"=>"Tout le monde", "id"=>0}, {"right"=>"Ma promo uniquement", "id"=>1}, {"right"=>"Moi uniquement", "id"=>2}]

end
