local selectedEntry = 1
local saveOntoEntry = 1
local name, ItakioPlayerNotes = ...
local f = CreateFrame("Frame")
IPNToBeDeletedEntryNum = 0

function ItakioPlayerNotes_OnEvent(self, event, ...)
if event == "ADDON_LOADED" and name == "ItakioPlayerNotes" then
    if not PlayerNotes then PlayerNotes = {} end
    IPNScrollBar:Show()
	IPN_MinimapButton:Show()
	PopulateEditBox() -- just to change title on initial load
	if not IPConfig then IPNConfig = {} end 
	IPNConfig["defaultSetting2"] = 1
	IPNConfig["defaultSetting2"] = 1
     f:UnregisterEvent("ADDON_LOADED")
	 
	 
end
end
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", ItakioPlayerNotes_OnEvent)

local UCFrame = CreateFrame("Frame")
UCFrame:RegisterEvent("UNIT_CONNECTION")
UCFrame:SetScript("OnEvent", function(self, event, ...)
local var1, var2 = ...
 PartyCheckToDisplayWarning(UnitName(var1))
end)

local UTFrame = CreateFrame("Frame")
UTFrame:RegisterEvent("UNIT_TARGET")
UTFrame:SetScript("OnEvent", function(self, event, ...)
local var1 = ...
	if var1 == "player" then
		if UnitName("target") then
			TargetCheckToDisplayWarning(UnitName("target"))
		end
	end
end)

SLASH_ITAKIOPLAYERNOTES1 = "/ipn"
SlashCmdList["ITAKIOPLAYERNOTES"] = function(msg)

	if msg == 'tgt' then
-- first check if tgt is on list
 	-- for i in ipairs(PlayerNotes) do
		-- if UnitName("target") == PlayerNotes[i][1] then
			-- selectedEntry = i
			-- IPNScrollBar_Update()
			-- NoteEditorFrame1:Show();
			-- PopulateEditBox();
			-- return
		-- end		
	-- end
	IPNAdd(UnitName("target"))
	NoteEditBox1:ClearFocus()
	else

	if getglobal("IPNMainFrame"):IsShown() then
	getglobal("IPNMainFrame"):Hide();
	else
	getglobal("IPNMainFrame"):Show();
	end
	
	end
end



-- SLASH_TEST1 = "/ipn test"; 
-- SlashCmdList.PLAYERNOTES = function()
	
-- end

-- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function IPN_MinimapButton_Reposition()
	IPN_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(IPNConfig.MinimapPos)),(80*sin(IPNConfig.MinimapPos))-52)
end

-- Only while the button is dragged this is called every frame
function IPN_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	IPNConfig.MinimapPos = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	IPN_MinimapButton_Reposition() -- move the button
end

-- function IPN_MinimapButton_OnEnter(self)
	-- if (self.dragging) then
		-- return
	-- end
	-- IPNTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT")
	-- IPN_MinimapButton_Details(IPNTooltip)
-- end


-- function IPN_MinimapButton_Details(tt, ldb)
	-- tt:SetText("Itakio Player Notes")
-- end

function IPN_MinimapButton_OnClick()
	if getglobal("IPNMainFrame"):IsShown() then
	getglobal("IPNMainFrame"):Hide();
	else
	getglobal("IPNMainFrame"):Show();
	end
end

function IPNScrollBar_Update()
  local line; -- 1 through 5 of our window to scroll
  local lineplusoffset; -- an index into our data calculated from the scroll offset
  FauxScrollFrame_Update(IPNScrollBar,#PlayerNotes,15,16);
  for line=1,15 do
    lineplusoffset = line + FauxScrollFrame_GetOffset(IPNScrollBar);
		if lineplusoffset<=#PlayerNotes then
			getglobal("EntryRow"..line.."HBtnH"):Hide();
				if lineplusoffset == selectedEntry then
				getglobal("EntryRow"..line.."HBtnH"):Show();
				end
			getglobal("EntryRow"..line):Show();
			getglobal("EntryRow"..line.."Text"):SetText(PlayerNotes[lineplusoffset][1]);
			getglobal("EntryRow"..line.."ChildFontFrame1Text"):SetText(date("%m/%d/%y", PlayerNotes[lineplusoffset][2]));
			getglobal("EntryRow"..line.."ChildFontFrame2Text"):SetText(PlayerNotes[lineplusoffset][3]);
		else
      getglobal("EntryRow"..line):Hide();
    end
  end
end



function IPNConstructEditBox1()
  NoteEditBox1:SetPoint("TOPLEFT", NoteEditorFrame1.InsetBg, "TOPLEFT", 5, -5);
            NoteEditBox1:SetPoint("BOTTOMRIGHT", NoteEditorFrame1.InsetBg, "BOTTOMRIGHT", -5, 5);
            NoteEditBox1:SetText("test1");
            NoteEditBox1:SetHitRectInsets(0, 0, 0, 0);
            NoteEditBox1:SetMultiLine(true);
            -- NoteEditBox1:SetScript("OnEscapePressed", function() NoteEditorFrame1:ClearFocus() end)
			-- NoteEditBox1:SetFrameStrata("LOW")
			end
			
function ConstructIPNExportEditBox1()
    IPNExportEditBox1:SetPoint("TOPLEFT", IPNExportFrame.InsetBg, "TOPLEFT", 5, -5);
    IPNExportEditBox1:SetPoint("BOTTOMRIGHT", IPNExportFrame.InsetBg, "BOTTOMRIGHT", -5, 5);
    IPNExportEditBox1:SetHitRectInsets(0, 0, 0, 0);
    IPNExportEditBox1:SetMultiLine(true);
    IPNExportEditBox1:SetAutoFocus(true)
end

function IPNExportEditBox1AfterExportClick()
IPNExportEditBox1:SetText("");
firstLineWritten = false
	for i in ipairs(PlayerNotes) do
		if firstLineWritten then
			IPNExportEditBox1:Insert("\n")
		end
		for i,v in ipairs(PlayerNotes[i]) do
		
			if i == 2 then
				if firstLineWritten then
					IPNExportEditBox1:Insert("\n"..date("%m/%d/%y", v));		
				else 			
					IPNExportEditBox1:Insert(date("%m/%d/%y", v));
					firstLineWritten = true
				end
			elseif firstLineWritten then
				IPNExportEditBox1:Insert("\n"..v);		
			else 			
				IPNExportEditBox1:Insert(v);
				firstLineWritten = true
			end
		end
	end
end

-- function initIPNExportEditBox1ForTesting()

	-- a1 = {}
	-- a1[1]={}
	-- a1[1][1] = "Alex"
	-- a1[1][2] = "500"
	-- a1[1][3] = "300"
	-- a1[2]={}
	-- a1[2][1] = "Kathy"
	-- a1[2][2] = "150"
	-- a1[2][3] = "200"
	-- a1[3]={}
	-- a1[3][1] = "Brad"
	-- a1[3][2] = "50"
	-- a1[3][3] = "70"
	-- a1[4]={}
	-- a1[4][1] = "Zimmerman"
	-- a1[4][2] = "2000"
	-- a1[4][3] = "230232"
	-- a1[5]={}
	-- a1[5][1] = "Edelgard"
	-- a1[5][2] = "333"
	-- a1[5][3] = "2220"
	-- a1[6]={}
	-- a1[6][1] = "Raphael"
	-- a1[6][2] = "34334"
	-- a1[6][3] = "2424242"
	
	-- for i in pairs(a1) do
		-- for i,v in pairs(a1[i]) do
			-- IPNExportEditBox1:Insert(v.."     ");
		-- end
	-- IPNExportEditBox1:Insert("\n")
	-- end
	
-- end
--DELETE WHEN FINISHED WITH ADDON

function IPNSortByName()
table.sort(PlayerNotes,function(a, b) 
	return a[1] < b[1]
	end)
	IPNScrollBar_Update()
end

function IPNSortByDate()
table.sort(PlayerNotes,function(a, b) 
	return a[2] < b[2]
	end)
	IPNScrollBar_Update()
end

-- function testTableSorting()
	-- IPNExportEditBox1:SetText("")
	
	-- table.sort(a1,function(a, b) 
	-- return tonumber(a[2]) < tonumber(b[2])
	-- end)
	
	
	-- for i in pairs(a1) do
		-- for i,v in pairs(a1[i]) do
			-- IPNExportEditBox1:Insert(v.."     ");
		-- end
	-- IPNExportEditBox1:Insert("\n")
	-- end
-- end




            
function IPNAdd(playerName)
    for i in ipairs(PlayerNotes) do
		if playerName == PlayerNotes[i][1] then
			selectedEntry = i
			IPNScrollBar_Update()
			NoteEditorFrame1:Show();
			PopulateEditBox();
			return
		end
	end
            if not PlayerNotes then PlayerNotes = {} end
				ListCount = table.maxn(PlayerNotes)
				PlayerNotes[ListCount+1] = {}
				PlayerNotes[ListCount+1][1] = playerName
				PlayerNotes[ListCount+1][2] = time()
				PlayerNotes[ListCount+1][3] = "" -- general note
				PlayerNotes[ListCount+1][4] = tostring("WARNING! "..playerName.." has an entry in IPN") -- warning note
				if IPNConfig["defaultSetting1"] then 
					PlayerNotes[ListCount+1][5] = IPNConfig["defaultSetting1"] 
				else 
					PlayerNotes[ListCount+1][5] = 1
				end
				if IPNConfig["defaultSetting2"] then 
					PlayerNotes[ListCount+1][6] = IPNConfig["defaultSetting2"] 
				else 
					PlayerNotes[ListCount+1][6] = 1
				end
				selectedEntry=ListCount+1
				IPNScrollBar_Update()
				IPNUpdateWarningEditBox()
                NoteEditorFrame1:Show();
				PopulateEditBox();
				ScrollToBottom();
end

function IPNEntryExists(playerName)
	
end

function IPNSetSelectedEntry(BtnNum)
selectedEntry=BtnNum+FauxScrollFrame_GetOffset(IPNScrollBar);
IPNScrollBar_Update()
IPNUpdateWarningEditBox()
end

function IPNSaveEntry()
    PlayerNotes[saveOntoEntry][3]=NoteEditBox1:GetText();
	IPNScrollBar_Update()
end

function IPNSetSelectedToBeDeleted()
	IPNToBeDeletedEntryNum = selectedEntry
end

function IPNDeleteToBeDeletedEntry()
	-- vv don't leave a non-entry highlighted vv
	local selectedEntryTemp
	if #PlayerNotes == IPNToBeDeletedEntryNum then 
	selectedEntryTemp = IPNToBeDeletedEntryNum-1 
    table.remove(PlayerNotes, IPNToBeDeletedEntryNum)
	selectedEntry = selectedEntryTemp
	IPNScrollBar_Update()
	else
	table.remove(PlayerNotes, IPNToBeDeletedEntryNum)
	IPNScrollBar_Update()
	end
end

function IPNEditBoxOnClick()
				if #PlayerNotes >= selectedEntry then
                PopulateEditBox()
                NoteEditorFrame1:Show();
                end
end

function PopulateEditBox()
if PlayerNotes[selectedEntry] then
	NoteEditBox1:SetText(PlayerNotes[selectedEntry][3]);
	NoteEditorFrame1.TitleText:SetText("IPN - "..PlayerNotes[selectedEntry][1] )
	saveOntoEntry=selectedEntry
	end
end

function IPNDefaultBtnOnClick()
	IPNConfig["defaultSetting1"] = PlayerNotes[selectedEntry][5]
	IPNConfig["defaultSetting2"] = PlayerNotes[selectedEntry][6]
end


function IPNUpdateWarningEditBox()
	if PlayerNotes[1] then -- just avoiding lua error if list is empty
                        if #PlayerNotes[selectedEntry] >= 4 then
                        IPNMainFrameExpandedFrameEditBoxContainerFrameEditbox:SetText(PlayerNotes[selectedEntry][4])
						if PlayerNotes[selectedEntry][5] == 1 then IPNMainFrameExpandedFrameCheckButton1:SetChecked(true) else IPNMainFrameExpandedFrameCheckButton1:SetChecked(false)  end
						if PlayerNotes[selectedEntry][6] == 1 then IPNMainFrameExpandedFrameCheckButton2:SetChecked(true) else IPNMainFrameExpandedFrameCheckButton2:SetChecked(false)  end
						else -- possibly bad code 8/24
						IPNMainFrameExpandedFrameEditBoxContainerFrameEditbox:SetText("")
                        end
	end
end



function PartyCheckToDisplayWarning(playerName)
	for i in ipairs(PlayerNotes) do
		if PlayerNotes[i][1] == playerName then 
			if PlayerNotes[i][5] == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(PlayerNotes[i][4], 1.0, 0.0, 0.0)
			end
		end
	end
end

function TargetCheckToDisplayWarning(playerName)
	for i in ipairs(PlayerNotes) do
		if PlayerNotes[i][1] == playerName then 
			if PlayerNotes[i][6] == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(PlayerNotes[i][4], 1.0, 0.0, 0.0)
			end
		end
	end
end

function CheckButtonOnClick(checkBtnNum)
local entryNumToMod = (4 + checkBtnNum) -- a stupid way of saving some code over only 2  check buttons
if getglobal("IPNMainFrameExpandedFrameCheckButton"..checkBtnNum):GetChecked() == false then 
PlayerNotes[selectedEntry][entryNumToMod] = 0 
else 
PlayerNotes[selectedEntry][entryNumToMod] = 1
end
end

function IPNExpandedEditboxOnTextChanged()
	if PlayerNotes[1] then
	PlayerNotes[selectedEntry][4] = IPNMainFrameExpandedFrameEditBoxContainerFrameEditbox:GetText()
	end
end

function ScrollToBottom()
	-- local min, max = IPNScrollBar:GetMinMaxValues();
	if #PlayerNotes>15 then
	local min, max = IPNScrollBarScrollBar:GetMinMaxValues()
	
	IPNScrollBarScrollBar:SetValue(max)
	end
	end