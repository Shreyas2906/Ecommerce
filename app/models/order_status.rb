class OrderStatus < ApplicationRecord
	enum status: %i[created inprocess dilevered cancelled]
	enum refund: %i[in-process success failed]
end
