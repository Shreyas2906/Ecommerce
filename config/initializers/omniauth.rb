Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '250162603965837|kK9IAVHugFsfA8POKcl6x4wUpks', 'EAADjhYUlPY0BAMUQnOvwJY9TszNXWjHXfiLbHltUdYWNEWZC02zqMBS2EuMa3qT0vudlEyjOriBv3qDdkJdLec6EDRPGQ1vL5X2whTrjoxzyr76qlGTHZASyoZBPZCo0rnetatqZA0lZA2KlAZA9q5CoGsMhlc3duZAMZB7v5j7m6Tnlrtvf2tqsOyhrVRZBm4v0UdpZBaGDuKEXTZCZBeXzZAEZAJw2Mt9i1TMUVnZADGNJwY3qZBD5PSa0mZASYc'
  provider :linkedin, '77ryk6l2vi4ri0', 'RkkIBGSyrhvOjzQj'
  provider :google_oauth2, '244615150400-05thnta81fhg631up71t8v7e167i8pta.apps.googleusercontent.com', 'XW9LFZYGtLjruVh9kOpmCaRY' 
  provider :github, "4495240852d57f81e108", "248f4500a59eabf7e10d5c024e6985ce2d96b18b", :scope => 'email'
  provider :twitter, 'y6kILe3VwuGpaFIIfPXdnv8pw', 'Gb76xJS6ZvTrzzxp0jNFLnZG2nNhNaaNPfx5FAWLrL5y11e14D'
end
