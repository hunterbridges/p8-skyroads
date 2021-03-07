timer0 = 0
timer1 = 0
fade = 0

sp_text = "TELEMETRY"
sp_len = 0

function STATE_SPLASH()
    if timer0 < 60 then
        fade = 255 * timer0 / 60
    elseif timer0 < 60 * 4 then
        fade = 255

        if timer1 == 0 and sp_len < #sp_text then
            sfx(4)
            sp_len = sp_len + 1
            timer1 = 8
        end

        timer1 = timer1 - 1

        if btnp(4) then
            sp_len = #sp_text
            timer0 = 60 * 4
        end
    elseif timer0 < 60 * 5 then
        fade = 255 * (60 - (timer0 - 60 * 4)) / 60
    elseif timer0 < 60 * 5.5 then
        -- nothing
    else
        game_state = STATE_RUNNING
    end

    fade = flr(fade)
    timer0 = timer0 + 1
end

function STATE_TITLE()
end

function STATE_READY()
	update_bg()
end

function STATE_RUNNING()
	update_bg()
	update_ship()
end

function STATE_DEAD()
	update_bg()
end

function STATE_VICTORY()
	update_bg()
end

function update_game()
    game_state()
end

function draw_game()
	cls()
    if game_state == STATE_SPLASH then
        draw_fade(fade)
        if sp_len > 0 then
            print(sub(sp_text, 0, sp_len), 127 - 36, 127 - 6, 0)
        end
    elseif game_state == STATE_TITLE then
    elseif game_state == STATE_READY then
        draw_bg()
        draw_fg()
    elseif game_state == STATE_RUNNING then
        draw_bg()
        draw_fg()
    elseif game_state == STATE_DEAD then
        draw_bg()
        draw_fg()
    elseif game_state == STATE_VICTORY then
        draw_bg()
        draw_fg()
    end
end

game_state = STATE_RUNNING
