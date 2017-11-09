#!/usr/bin/env ruby
require "curses"

module Vir
  class Editor
    def initialize
      Curses.init_screen
      Curses.raw
      set_escdelay(25)

      Curses.setpos(0,0)
      Curses.addstr("Press Ctrl + c")
      Curses.refresh

      @win = Curses::Window.new(Curses.lines - 2,Curses.cols,2,0)
      editor_start  
    end

    def editor_start
      @win.scrollok(true)
      begin
      @win.keypad(true)

      x = 0
      y = 0
      taple_end = Array.new

      loop do
        key = nil
        @win.setpos(y,x)
        key = @win.getch
        if key == Curses::KEY_CTRL_C
          break
        end
          
        case key
          when Curses::Key::DL,Curses::Key::BACKSPACE
            @win.setpos(y,x - 1)
            @win.delch
            if !x.zero?
              x -= 1
            else
              if !@win.cury.zero?
                y -= 1
                x = taple_end[y]
              end
            end
          when 10
            taple_end[y] = x
            x = 0
            y += 1
          else
            print_key_info(@win,y,x,key)
            x += 1
        end
      end
      ensure
        Curses.close_screen
      end
    end
    
    def set_escdelay(ms)
      Curses.ESCDELAY = ms
      rescue NotImplementedError
    end

    def print_key_info(win,y,x,key)
      win.setpos(y,x)
      win.addstr(key)
    end
  end
end
