require "./lib/museum"
require "./lib/patron"
require "./lib/exhibit"

describe Museum do
  describe "Iteration 1 & 2" do
    before :each do
      @dmns = Museum.new("Denver Museum of Nature and Science")
      @gems_and_minerals = Exhibit.new({ name: "Gems and Minerals", cost: 0 })
      @dead_sea_scrolls = Exhibit.new({ name: "Dead Sea Scrolls", cost: 10 })
      @imax = Exhibit.new({ name: "IMAX", cost: 15 })
      @patron_1 = Patron.new("Bob", 20)
      @patron_2 = Patron.new("Sally", 20)
    end

    it "exists" do
      expect(@dmns).to be_a(Museum)
    end

    it "has a name" do
      expect(@dmns.name).to eq("Denver Museum of Nature and Science")
    end

    it "has no exhibits to start" do
      expect(@dmns.exhibits).to eq([])
    end

    it "can add exhibits" do
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@imax)

      expect(@dmns.exhibits).to eq([@gems_and_minerals, @dead_sea_scrolls, @imax])
    end

    it "can recommend exhibits based on patrons interests" do
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@imax)

      @patron_1.add_interest("Dead Sea Scrolls")
      @patron_1.add_interest("Gems and Minerals")
      @patron_2.add_interest("IMAX")

      expect(@dmns.recommend_exhibits(@patron_1)).to eq([@gems_and_minerals, @dead_sea_scrolls])
      expect(@dmns.recommend_exhibits(@patron_2)).to eq([@imax])
    end
  end

  describe "Iteration 3" do
    before :each do
      @dmns = Museum.new("Denver Museum of Nature and Science")
      @gems_and_minerals = Exhibit.new({ name: "Gems and Minerals", cost: 0 })
      @dead_sea_scrolls = Exhibit.new({ name: "Dead Sea Scrolls", cost: 10 })
      @imax = Exhibit.new({ name: "IMAX", cost: 15 })
      @patron_1 = Patron.new("Bob", 0)
      @patron_2 = Patron.new("Sally", 20)
      @patron_3 = Patron.new("Johnny", 5)
      @patron_1.add_interest("Gems and Minerals")
      @patron_1.add_interest("Dead Sea Scrolls")
      @patron_2.add_interest("Dead Sea Scrolls")
      @patron_3.add_interest("Dead Sea Scrolls")
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@imax)
    end

    it "tracks patrons by admittance and exhibit interest" do
      expect(@dmns.patrons).to eq([])
      @dmns.admit(@patron_1)
      @dmns.admit(@patron_2)
      @dmns.admit(@patron_3)

      expect(@dmns.patrons).to eq([@patron_1, @patron_2, @patron_3])

      expect(@dmns.patrons_by_exhibit_interest).to eq({
                                                     @gems_and_minerals => [@patron_1],
                                                     @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
                                                     @imax => [],
                                                   })
    end

    it 'has a lottery for patrons who cannot afford an exhibit' do
      @dmns.admit(@patron_1)
      @dmns.admit(@patron_2)
      @dmns.admit(@patron_3)

      expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to eq([@patron_1, @patron_3])

      allow(@dmns).to receive(@dmns.draw_lottery_winner(@dead_sea_scrolls)).and_return(:sample) 

      expect(@dmns.draw_lottery_winner(@imax)).to eq(nil)
      #If no contestants are elgible for the lottery, nil is returned.

      expect(@dmns.announce_lottery_winner(@dead_sea_scrolls)).to eq("#{name} has won the IMAX exhibit lottery")
      #In the interaction pattern this said imax, but no one was interested in the imax, so I assumed it was a lottery for dead_sea_scrolls
      expect(@dmns.announce_lottery_winner(@gems_and_minerals))
    end
  end
end
