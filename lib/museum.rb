class Museum
  attr_reader :name,
              :exhibits,
              :patrons,
              :lottery_contestants

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @lottery_contestants = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    recommended_exhibits = []
    @exhibits.each do |exhibit|
      patron.interests.each do |interest|
        if exhibit.name == interest
          recommended_exhibits << exhibit
        end
      end
    end
    recommended_exhibits
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    patrons_by_exhibit_interest = Hash.new { |h, k| h[k] = [] }
    @exhibits.each do |exhibit|
      @patrons.each do |patron|
        if patron.interests.include?(exhibit.name)
          patrons_by_exhibit_interest[exhibit] << patron
        elsif patrons_by_exhibit_interest[exhibit].nil?
          patrons_by_exhibit_interest = []
        end
      end
    end
    patrons_by_exhibit_interest
  end

  def ticket_lottery_contestants(exhibit)
       @patrons.each do |patron|
        if patron.interests.include?(exhibit.name) && patron.spending_money < exhibit.cost
          @lottery_contestants << patron
        end
      end
      @lottery_contestants
    end

    def draw_lottery_winner(exhibit)
      @lottery_contestants.sample
    end
  end