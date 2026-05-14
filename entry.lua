--- To change it refer to https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-key
local KEYCODE = 4194335 --- KEY_F4

local DEFAULT_TRANSACTION_AMOUNT  = 1000
local DEFAULT_TRANSACTION_DETAILS = "斌少至尊VIP补助"

function on_engine_load()
    print( "斌少金钱修改器" )
    ModApiV1.sanity()
end

--- @param event InputEvent
function on_player_input( event )
    if event.get_class() == "InputEventKey" then
        if not ( event.is_pressed() and event.get_keycode() == KEYCODE ) then return end

        local vbox = create_node( "VBoxContainer", "" )

        --- Amount of cash
        local label_amount = create_node( "Label", "" )
        label_amount.text = "金额"
        vbox.add_child( label_amount )
        local ledit_amount = create_node( "LineEdit", "" )
        vbox.add_child( ledit_amount )

        --- Transaction details
        local label_msg = create_node( "Label", "" )
        label_msg.text = "交易详情"
        vbox.add_child( label_msg )
        local ledit_msg = create_node( "LineEdit", "" )
        ledit_msg.max_length = 30
        ledit_msg.placeholder_text = DEFAULT_TRANSACTION_DETAILS
        vbox.add_child( ledit_msg )

        --- Transaction category
        local label_cat = create_node( "Label", "" )
        label_cat.text = "交易类别"
        vbox.add_child( label_cat )
        local ddown_cat = create_node( "OptionButton", "" )
        ddown_cat.add_item( "UNKNOWN", 0 )
        ddown_cat.add_item( "收入", 1 )
        ddown_cat.add_item( "资本支出", 2 )
        ddown_cat.add_item( "运营支出", 3 )
        ddown_cat.add_item( "琐碎的", 4 )
        ddown_cat.add_item( "贷款", 5 )
        ddown_cat.add_item( "利息", 6 )
        ddown_cat.add_item( "投资", 7 )
        ddown_cat.add_item( "捐赠", 8 )
        ddown_cat.add_item( "提案处理", 9 )
        ddown_cat.add_item( "交易", 10 )
        ddown_cat.add_item( "聚合", 11 )
        ddown_cat.add_item( "处罚", 12 )
        ddown_cat.select( 1 )
        vbox.add_child( ddown_cat )

        --- Global dialog
        local dialog = create_node( "ConfirmationDialog", "" )
        dialog.title = "斌少金钱修改器"
        dialog.initial_position = 1
        dialog.show()
        dialog.add_child( vbox )

        dialog.connect( "confirmed", function()
            local amount = ledit_amount.text
            local amount_num = DEFAULT_TRANSACTION_AMOUNT
            if amount ~= "" then
                amount_num = tonumber( amount, 10 )
                if amount_num == nil then return end --- TODO: upgrade by adding color on ledit_amount border
            end
            print( "amount_num: " .. amount_num )

            local details = ledit_msg.text
            if details == "" then details = DEFAULT_TRANSACTION_DETAILS end
            print( "details: " .. details )

            local category = ddown_cat.get_selected_id()
            print( "category: " .. category )

            ModApiV1.get_game_world().modify_player_cash( amount_num, details, category )
            dialog.queue_free()
        end)
        dialog.connect( "canceled", function()
            dialog.queue_free()
        end)

        Mod.add_child( dialog )
    end
end