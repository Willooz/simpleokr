global_events_prefix :ab

version 1, "2015-07-14" do
  category :user do
    event :visit, "2015-07-14", "user visits home page"
    event :start, "2015-07-14", "user starts OKR definition (1/2)"
    event :registration, "2015-07-14", "user registered and continues OKR defintion (2/2)"
    event :creation, "2015-07-14", "user created an OKR"
    event :share_twitter, "2015-07-14", "user shared an OKR on Twitter"
    event :share_linkedin, "2015-07-14", "user shared an OKR on LinkedIn"
    event :review, "2015-07-14", "user reviewed an OKR"
  end
end