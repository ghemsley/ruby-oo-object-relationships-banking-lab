class BankAccount
  TRANSACTION_REJECTED = 'Transaction rejected. Please check your account balance.'.freeze
  STATUS_OPEN = 'open'.freeze
  STATUS_CLOSED = 'closed'.freeze
  @@all = []
  attr_accessor :status
  attr_reader :name, :balance
  attr_writer :balance
  def initialize(name)
    @name = name.freeze
    @balance = 1000
    @status = STATUS_OPEN
    @@all.push(self)
  end

  def deposit(integer)
    self.balance += integer
  end

  def withdrawal(integer)
    if self.balance > integer
      self.balance -= integer
      self.balance
    else
      p TRANSACTION_REJECTED
    end
  end

  def display_balance
    p "Your balance is $#{balance}."
  end

  def valid?
    balance.positive? && status == STATUS_OPEN
  end

  def close_account
    self.status = STATUS_CLOSED
    self.status.freeze
  end

  def self.all
    @@all
  end

end
