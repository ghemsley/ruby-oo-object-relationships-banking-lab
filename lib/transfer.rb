class Transfer
  TRANSACTION_REJECTED = 'Transaction rejected. Please check your account balance.'.freeze
  STATUS_COMPLETE = 'complete'.freeze
  STATUS_PENDING = 'pending'.freeze
  STATUS_REJECTED = 'rejected'.freeze
  STATUS_REVERSED = 'reversed'.freeze
  @@all = []
  attr_reader :sender, :receiver, :amount, :status
  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @amount = amount
    @amount.freeze
    @status = STATUS_PENDING
    @@all.push(self)
  end

  def status=(status)
    if ![STATUS_PENDING, STATUS_COMPLETE, STATUS_REJECTED, STATUS_REVERSED].freeze.include?(status)
      p 'Error: invalid status'
    else
      @status = status
      self.status.freeze if self.status == STATUS_REJECTED || self.status == STATUS_REVERSED
    end
  end

  def valid?
    sender.valid? && receiver.valid? && sender.balance >= amount
  end

  def reverse_valid?
    sender.valid? && receiver.valid? && receiver.balance >= amount
  end

  def reject_transaction
    self.status = STATUS_REJECTED
    status.freeze
    p TRANSACTION_REJECTED
  end

  def execute_transaction
    if valid? && ![STATUS_COMPLETE, STATUS_REJECTED, STATUS_REVERSED].freeze.include?(status)
      sender.withdrawal(amount)
      receiver.deposit(amount)
      self.status = STATUS_COMPLETE
    else
      reject_transaction
    end
  end

  def reverse_transfer
    last_transaction = self.class.all.select do |transaction|
      transaction.status == STATUS_COMPLETE
    end[-1]
    if last_transaction.reverse_valid?
      last_transaction.receiver.withdrawal(last_transaction.amount)
      last_transaction.sender.deposit(last_transaction.amount)
      last_transaction.status = STATUS_REVERSED
    else
      last_transaction.reject_transaction
    end
  end

  def self.all
    @@all
  end

  private

  attr_writer :sender, :receiver, :amount
end
