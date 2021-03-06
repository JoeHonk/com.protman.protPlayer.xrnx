--------------------------------------------------------------------------------
-- Batch Rendering Tool
--
-- Copyright 2011 Martin Bealby
--
-- GUI support code
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
dialog = nil


--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
function dialog_show()

  -- Already visible?
  if (dialog and dialog.visible) then 
    return 
  end
  
  -- View layout builder & consts
  local vb = renoise.ViewBuilder()

  local SWITCH_WIDTH = 140
  local POPUP_WIDTH = 140
  
  local CONTENT_SPACING = 
    renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
    
  local DEFAULT_DIALOG_BUTTON_HEIGHT = 
    renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT
  
  local DEFAULT_DIALOG_MARGIN = 
    renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
  
  -- Convert parameters to vb values 
  local priority_value
  if renoise.tool().preferences.priority.value == "low" then
    priority_value = 1
  elseif renoise.tool().preferences.priority.value == "realtime" then
    priority_value = 2
  else
    priority_value = 3
  end
  
  local samplerate_value
  if renoise.tool().preferences.samplerate.value == 44100 then
    samplerate_value = 1
  elseif renoise.tool().preferences.samplerate.value == 48000 then
    samplerate_value = 2
  elseif renoise.tool().preferences.samplerate.value == 88200 then
    samplerate_value = 3
  else
    samplerate_value = 4
  end
  
  local bitdepth_value
  if renoise.tool().preferences.bitdepth.value == 16 then
    bitdepth_value = 1
  elseif renoise.tool().preferences.bitdepth.value == 24 then
    bitdepth_value = 2
  else
    bitdepth_value = 3
  end

  local interpolation_value
  if renoise.tool().preferences.interpolation.value == "cubic" then
    interpolation_value = 1
  else
    interpolation_value = 2
  end
  
  
     
  -- Build controls
  local priority = vb:horizontal_aligner {
    mode = "justify",
    vb:text {
      text = "Priority:"
    },
    vb:popup {
      items = {"Low", "Realtime", "High"},
      value = priority_value,
      width = POPUP_WIDTH,
      notifier = function(v)
        if v == 1 then
          renoise.tool().preferences.priority.value = "low"
        elseif v == 2 then
          renoise.tool().preferences.priority.value = "realtime"
        else
          renoise.tool().preferences.priority.value = "high"
        end
      end,
    }
  }
  
  local sample_rate = vb:horizontal_aligner {
    mode = "justify",
    vb:text {
      text = "Sample rate:"
    },
    vb:popup {
      items = {"44100", "48000", "88200", "96000"},
      value = samplerate_value,
      width = POPUP_WIDTH,
      notifier = function(v)
        if v == 1 then
          renoise.tool().preferences.samplerate.value = 44100
        elseif v == 2 then
          renoise.tool().preferences.samplerate.value = 48000
        elseif v == 3 then
          renoise.tool().preferences.samplerate.value = 88200
        else
          renoise.tool().preferences.samplerate.value = 96000
        end
      end,
    }
  }
  
  local bit_depth = vb:horizontal_aligner {
    mode = "justify",
    vb:text {
      text = "Bitdepth:"
    },
    vb:popup {
      items = {"16", "24", "32"},
      value = bitdepth_value,
      width = POPUP_WIDTH,
      notifier = function(v)
        if v == 1 then
          renoise.tool().preferences.bitdepth.value = 16
        elseif v == 2 then
          renoise.tool().preferences.bitdepth.value = 24
        else
          renoise.tool().preferences.bitdepth.value = 32
        end
      end,
    }
  }
  
  local interpolation = vb:horizontal_aligner {
    mode = "justify",
    vb:text {
      text = "Interpolation:"
    },
    vb:popup {
      items = {"Cubic", "Arguru's Sinc"},
      value = 1,
      width = POPUP_WIDTH,
      notifier = function(v)
        if v == 1 then
          renoise.tool().preferences.interpolation.value = "cubic"
        else
          renoise.tool().preferences.interpolation.value = "sinc"
        end
      end,
    }
  }
      
    
  -- Build dialog content
  local dialog_content = vb:column {
    spacing = CONTENT_SPACING,
    margin = DEFAULT_DIALOG_MARGIN,
  
    priority,
    sample_rate,
    bit_depth,
    interpolation,
    
    vb:space { height = 2*CONTENT_SPACING },
    
    vb:horizontal_aligner {
      mode = "justify",
      spacing = DEFAULT_DIALOG_MARGIN,

      vb:button {
        width = 100,
        height = DEFAULT_DIALOG_BUTTON_HEIGHT,
        text = "Start",
        notifier = function()
          dialog:close()
          OneShotIdleNotifier(0.0, batch_render) --workaround
        end
      },
      
      vb:button {
        width = 100,
        height = DEFAULT_DIALOG_BUTTON_HEIGHT,
        text = "Cancel",
        notifier = function()
          renoise.app():show_status("Batch rendering cancelled.")
          dialog:close()
        end
      },
    },
  }
  
  -- show
  -- dialog = renoise.app():show_custom_dialog("Batch Rendering", dialog_content)
end
