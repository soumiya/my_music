class Song < ActiveRecord::Base
   
   belongs_to :user
   include HTTParty
   base_uri 'itunes.apple.com'
   validates :track_id, :presence => true

   after_initialize :set_defaults
   



   def self.search(search)
       results=[]
       begin
          options={:wrapperType => :track}
          options[:term]=search.strip.gsub(/\W/,'+')
          res=get('/search',:query=>options)
          if(res.code == 200)
            res.parsed_response.recursively_symbolize_keys![:results].each{ |item|
              track=new
              track[:track_id]=item[:trackId]
              track[:track_name]=item[:trackName]
              track[:track_view_url]=item[:trackViewUrl]
              track[:artist_name]=item[:artistName]
              track[:genre]=item[:primaryGenreName]
              track[:cover_url]=item[:artworkUrl60]
              results << track
            }

          end
       rescue => e
          logger.debug e.message
       end
       results
   end

   
   def self.lookup(*args)
       results=[]
       begin
         lookups= args.flatten.map(&:to_i).join(',')
         res=get('/lookup',:query=>{:id => lookups})
          if(res.code == 200)
            res.parsed_response.recursively_symbolize_keys![:results].each{ |item|
              track=new
              track.track_id=item[:trackId]
              track.track_name=item[:trackName]
              track.track_view_url=item[:trackViewUrl]
              track.artist_name=item[:artistName]
              track.genre=item[:primaryGenreName]
              track.cover_url=item[:artworkUrl60]    
              results << track
            }
          end
       rescue => e
          logger.debug("Song lookup err: #{e.message}")
       end
         results    
   end



  protected
      def set_defaults
         track_name||=:untitled
         artist_name||=:unknown
         genre||=:unknown
      end



end
