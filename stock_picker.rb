PRICE_DAYS = [17,3,6,9,15,8,6,1,10]

def stock_picker(array)
    #searches for obvious solution - namely that min is before max
    if ((max_index = array.find_index(array.max())) > (min_index = array.find_index(array.min())))
    # max_index = array.find_index(array.max())
    # min_index = array.find_index(array.min())
        return [min_index, max_index]
    else
        price_n_index = array.map.with_index {|price, index| [price, index]}.sort
        current_profit = nil
        current_buy_index = nil
        current_sell_index = nil
        price_n_index.each do |buy_price, buy_index|
            price_n_index.each do |sell_price, sell_index|
                if !current_profit || (sell_price - buy_price > current_profit && buy_index < sell_index)
                    current_buy_index = buy_index
                    current_sell_index = sell_index
                    current_profit = sell_price - buy_price
                end
            end
        end
        return [current_buy_index, current_sell_index]
    end
end

print stock_picker(PRICE_DAYS)
print stock_picker([1,2,3,4,5,6,7,8])