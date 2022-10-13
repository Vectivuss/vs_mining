function VectivusMining:NpcMenu( p )
    if !IsValid( p ) and !p:IsPlayer() then return end
    local w, h = ScrW(), ScrH()

    local _selectedTab
    local closeMat = Material( "vs_mining/close.png", "noclamp smooth" )
    local gradientDown = Material( "gui/gradient_down", "noclamp smooth" )
    local sid = p:SteamID()
    local lvl = self:getPlayerLevel( sid )
    local xp = self:getPlayerXP( sid )
    local maxxp = self:getMaxXP( sid )

    if IsValid( self.Background ) then
        self.Background:Remove()
    end

    // Background Menu //
    self.Background = vgui.Create( "DFrame" )
    self.Background:MakePopup()
    self.Background:SetAlpha( 0 )
	self.Background:AlphaTo( 255, .1, .05 )
    self.Background:SetTitle( "" )
    self.Background:DockPadding( 0, 0, 0, 0 )
    self.Background:SetSize( w, h )
    self.Background:SetDraggable( false )
    self.Background.Close = function( s ) 
        if s.CLOSE then return end
        s.CLOSE = true
		s:SetMouseInputEnabled( false )
		s:SetKeyboardInputEnabled( false )
		s:AlphaTo( 0, .1, .1, function() s:Remove() end )
        surface.PlaySound( "thepurge/sfx/popup.ogg" )
	end
    self.Background.OnMousePressed = function( s, k )
		if k == MOUSE_LEFT or k == MOUSE_RIGHT then
			s:Close()
		end
	end
    self.Background.Paint = function( s, w, h )
        if input.IsKeyDown( KEY_TAB ) then s:Close() end
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
    end
    // Background Menu //

    // Main Menu //
    local W, H = w*.7, h*.75
    self.DFrame = vgui.Create( "DPanel", self.Background )
    self.DFrame:SetAlpha( 0 )
	self.DFrame:AlphaTo( 255, .1, .05 )
    self.DFrame:DockPadding( 0, 0, 0, 0 )
    self.DFrame:SetSize( W, H )
    self.DFrame:Center()
    self.DFrame.Close = function( s )
        if s.CLOSING then return end
        s.CLOSING = true
	end
    self.DFrame.Paint = function( s, w, h )
        if self.Background.CLOSE then s:Close() end
        if input.IsKeyDown( KEY_TAB ) then s:Close() end
        lvl = self:getPlayerLevel( sid )
        xp = self:getPlayerXP( sid )
        maxxp = self:getMaxXP( sid )
        draw.RoundedBox( 8, 0, 0, w, h, Color( 155, 155, 155, 100 ) )
        draw.RoundedBox( 8, 1, 1, w-2, h-2, Color( 16, 8, 21, 250 ) )
    end

    local DPanel = vgui.Create( "DPanel", self.DFrame ) // Navbar
    DPanel:Dock( TOP )
    DPanel:DockMargin( W*.001, H*.002, W*.001, 0 )
    DPanel:SetTall( H*.07 )
    DPanel.Paint = function( s, w, h )
        surface.SetDrawColor( 155, 155, 155, 55 )
        surface.DrawRect( 0, h-2, w, 2 )
    end
    // Main Menu //

    // Close Menu //
    local DButton = vgui.Create( "DButton", DPanel )
    DButton:Dock( RIGHT )
    DButton:DockMargin( 0, 0, -W*.006, H*.025 )
    DButton:SetWide( W*.035 )
    DButton:SetText( "" )
    DButton.Paint = function( s, w, h )
        surface.SetDrawColor( ( s:IsHovered() and Color( 180, 43, 78 ) ) or Color( 220, 220, 220, 200 ) )
        surface.SetMaterial( closeMat )
        surface.DrawTexturedRectRotated( w/2, h/2, H*.016, H*.016, 0 )
    end
    DButton.DoClick = function( s, w, h ) self.Background:Close() end
    // Close Menu //

    // NavBar //
    local DNavbar = vgui.Create( "DPanel", DPanel )
    DNavbar:Dock( FILL )
    DNavbar:DockMargin( W*.381, H*.01, W*.2, 0 )
    DNavbar.Paint = nil 
    // NavBar //

	// Master Panel // 
    local DPopulate = vgui.Create( "DPanel", self.DFrame )
    DPopulate:Dock( FILL )
    DPopulate:DockMargin( W*.01, H*.03, W*.01, H*.035 )
    DPopulate.Paint = nil
	local function loadPanel( panel, func )
		DPopulate:AlphaTo( 0, .1, 0, function()
            if panel then _selectedTab = panel end
			DPopulate:Clear()
			func( DPopulate )
			DPopulate:AlphaTo( 255, .01, .05 )
		end )
	end
    // Master Panel // 

    local function Miningsystem_home()
        local DPanel = self:DPanel( DPopulate )
        DPanel:Dock( RIGHT )
        DPanel:SetWide( W*.185 )
        DPanel.PaintOver = function( s, w, h )
            // LEVEL & XP //
            lerpXP = Lerp( FrameTime() * 6, lerpXP or 0, xp )
            xpbar = math.Clamp( lerpXP/maxxp, 0, 1 )
            local x, y = w*.17, h*.04

            local xpProgress = ( lvl >= self.max_level and "[ Max Level ]" or "[ " .. math.ceil( lerpXP ) .. " / " .. maxxp .. " ]" )
            draw.RoundedBox( 16, x, y, w*.68, 4, Color( 0, 0, 0, 166 ) )
            draw.RoundedBox( 16, x, y, w*.68 * xpbar, 4, Color( 187, 64, 156 ) )
            draw.SimpleText( "Level: " .. lvl, "vs.mining.ui.16", x + ( w*.35 ), y + ( -h*.032 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
            draw.SimpleText( xpProgress, "vs.mining.ui.14", x + ( w*.35 ), y + ( h*.01 ), Color( 255, 255, 255, 140 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

            surface.SetDrawColor( 125, 125, 125, 55)
            surface.DrawRect( w*.08, h*.1, w*.84, 1 )
            // LEVEL & XP //
        end

        local DScrollPanel = self:DScrollPanel( DPopulate )
        DScrollPanel:Dock( FILL )
        DScrollPanel:DockMargin( 0, 0, 0, H*.01 )

        local rows = {}
        local oreAmount = table.Count( self.ores )
        for i=1, math.ceil( oreAmount / 4 ) do 
            local DPanel = vgui.Create( "DPanel", DScrollPanel )
            rows[i] = DPanel
            DPanel:Dock( TOP )
            DPanel:DockMargin( 0, 0, W*.002, H*.005 )
            DPanel:SetTall( H*.08 )
            DPanel.Paint = nil
        end

        local i = 0
        for k, t in SortedPairsByMemberValue( self.ores, "order" ) do
            i = i + 1
            if !IsValid( DScrollPanel ) then return end
            local row = rows[ math.ceil( i / 4 ) ]
            if !IsValid( row ) then break end

            local ore
            local oreName
            local color 
            local capacity

            local DPanel = vgui.Create( "DPanel", row )
            DPanel:Dock( LEFT )
            DPanel:DockMargin( 0, 0, W*.005, 0 )
            DPanel:SetWide( W*.192 )
            DPanel.Paint = function( s, w, h )
                ore = self:getOreVars( p, k )
                oreName = t.name
                color = t.color 
                capacity = t.capacity

                draw.RoundedBox( 4, 0, 0, w, h, ( s:IsHovered() and Color( 145, 145, 145, 55 ) or Color( 125, 125, 125, 55 ) ) )
                draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 22, 18, 30, 225 ) )

                local x, y = w*.02, h*.05
                local __, yy = draw.SimpleText( oreName, "vs.mining.ui.16", x, y, ( color or color_white ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                y = y + yy
                local __, yy = draw.SimpleText( ore .. "/" .. capacity, "vs.mining.ui.15", x, y, Color( 122, 122, 122 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                y = y + yy

                surface.SetDrawColor( 125, 125, 125, 55 )
                surface.DrawRect( w*.1, h-15, w*.8, 3 )
                
                local oreBar = math.Clamp( ore/capacity, 0, 1 )
                surface.SetDrawColor( color or color_white )
                surface.DrawRect( w*.1, h-15, w*.8 * oreBar, 3 )
            end
        end
    end

    local function Miningsystem_crafting()
        local selectedCraftable = nil
        
        local ores
        local DPanel = self:DPanel( DPopulate )
        DPanel:Dock( RIGHT )
        DPanel:SetWide( W*.185 )
        DPanel.Craftable = nil
        DPanel.PaintOver = function( s, w, h )
            s.Craftable = self:getItem( selectedCraftable )
            local t = s.Craftable
            local text = ( ( t and "[ " .. t.name .. " ]" ) or "" )
            draw.DrawText( text, "vs.mining.ui.22", w/2, h*.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
        end
        DModelPanel.PaintOver = function( s, w, h )
            if !DPanel.Craftable then return end
            local t = self:getItem( selectedCraftable )
            draw.RoundedBox( 6, 0, 0, w, h, Color( 125, 125, 125, 55 ) )
            draw.RoundedBox( 6, 1, 1, w-2, h-2, Color( 16, 8, 21, 225 ) )
        end

        local DPanelCraft = vgui.Create( "DPanel", DPanel )
        DPanelCraft:Dock( BOTTOM )
        DPanelCraft:DockMargin( W*.01, 0, W*.01, H*.025 )
        DPanelCraft:SetTall( H*.35 )
        DPanelCraft.Paint = function( s, w, h )
            surface.SetDrawColor( 125, 125, 125, 55)
            surface.DrawRect( 0, 0, w, 1 )
        end

        local DPanel = vgui.Create( "DPanel", DPanelCraft )
        DPanel:Dock( TOP )
        DPanel:DockMargin( 0, H*.01, 0, 0 )
        DPanel:SetTall( H*.28 )
        DPanel.Paint = nil

        local DCollapsibleCategory = vgui.Create( "DCollapsibleCategory", DPanel )
        DCollapsibleCategory:Dock( TOP )
        DCollapsibleCategory:SetLabel( "" )
        DCollapsibleCategory:SetExpanded( true )
        DCollapsibleCategory.Paint = function( s, w, h )
            local t = self:getItem( selectedCraftable )
            draw.SimpleText( ( t and "Materials:" or "" ), "vs.mining.ui.22", w*.01, h*.03, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end

        local DScrollPanel = VectivusMining:DScrollPanel( DPanel )
        DScrollPanel:Dock( FILL )

        ores = function() // generates ore requirements
            DScrollPanel:Clear()
            local craft = self:getItem( selectedCraftable )
            if !craft then return end
            for k, t in pairs( craft ) do
                if !self:getOre( k ) then continue end
                local text = ( k .. ": " .. t or 0 )
                local DLabel = vgui.Create( "DLabel" )
                DLabel:Dock( TOP )
                DLabel:DockMargin( H*.014, H*.006, 0, 0)
                DLabel:SetText( text )
                DLabel:SetFont( "vs.mining.ui.18" )
                DLabel:SetAutoStretchVertical( true )
                DScrollPanel:AddItem( DLabel )
                DLabel:SetWrap( true )
            end
        end

        local DButton = vgui.Create( "DButton", DPanelCraft )
        DButton:Dock( BOTTOM )
        DButton:SetTall( H*.05 )
        DButton:SetText( "" )
        DButton.Paint = function( s, w, h )
            draw.RoundedBox( 6, 0, 0, w, h, Color( 125, 125, 125, 55 ) )
            draw.RoundedBox( 6, 1, 1, w-2, h-2, Color( 16, 8, 21, 225 ) )

            local t = self:getItem( selectedCraftable )
            local text = ( ( t and t.name ) or "Craft" )

            draw.SimpleText( text, "vs.mining.ui.24", w/2, h/2, ( s:IsHovered() and Color( 75, 235, 109 ) or color_white ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        DButton.DoClick = function()
            if !selectedCraftable then return end
            RunConsoleCommand( "vs.mining.craftingitem", selectedCraftable )
            surface.PlaySound( "buttons/lever4.wav" )
        end

        local DPanel = vgui.Create( "DPanel", DPopulate )
        DPanel:Dock( FILL )
        DPanel:DockMargin( 0, 0, W*.01, 0 )
        DPanel:SetWide( W*.58 )
        DPanel.Paint = nil

        local filter = ""
        local populate
        local DTextEntry = vgui.Create( "DTextEntry", DPanel )
        DTextEntry:Dock( TOP )    
        DTextEntry:DockMargin( 0, 0, 0, H*.05 )  
        DTextEntry:SetTall( H*.04 )
        DTextEntry:SetFont( "vs.mining.ui.19" )
        DTextEntry.Paint = function( s, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, Color( 125, 125, 125, 55 ) )
            draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 16, 8, 21, 225 ) )

			s:DrawTextEntryText( Color(255,255,255,155), Color( 10, 103, 214 ), Color( 100, 100, 100 ) )
			if s:GetText() == "" then 
				draw.SimpleText( "Filter...", "vs.mining.ui.19", w*.005, h*.4, Color( 255,255,255,100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		end
        DTextEntry.OnChange = function( s )
            filter = s:GetValue()
            timer.Create( "vs_mining.populate", .5, 1, populate )
        end

        local craftables
        local DPanel = self:DPanel( DPanel )
        DPanel:Dock( BOTTOM )
        DPanel:SetTall( H*.815 )
        DPanel.Think = function()
            craftables = table.Count( self.craftables )
        end

        local DScrollPanel = self:DScrollPanel( DPanel )
        DScrollPanel:Dock( FILL )
        DScrollPanel:DockMargin( 0, 0, -W*.005, H*.02 )

        populate = function()
            if !IsValid( DScrollPanel ) then return end
            DScrollPanel:Clear()

            local rows = {}
            for i=1, math.ceil( craftables / 8 ) do 
                local DPanel = vgui.Create( "DPanel", DScrollPanel )
                rows[i] = DPanel
                DPanel:Dock( TOP )
                DPanel:DockMargin( W*.008, H*.02, W*.008, H*.01 )
                DPanel:SetTall( H*.14 )
                DPanel.Paint = nil
            end

            local i = 0
            for k, t in SortedPairsByMemberValue( self.craftables, "name", false ) do
                i = i + 1

                if ( !string.find( string.lower( t.name ), string.lower( filter ) ) ) then continue end

                if !IsValid( DScrollPanel ) then return end
                local row = rows[ math.ceil( i / 8 ) ]
                if !IsValid( row ) then break end

                local item = ( ( self:IsWeapon( k ) and weapons.Get( k ) ) or ( self:IsEntity( k ) and scripted_ents.Get( k ) ) or {} )
                local DButton = vgui.Create( "DButton", row )
                DButton:Dock( LEFT )
                DButton:DockMargin( 0, 0, W*.012, 0 )
                DButton:SetWide( H*.14 )
                DButton:SetText( "" )
                DButton.Paint = function( s, w, h )
                    s:SetModel( p:GetModel() )
                    draw.RoundedBox( 6, 0, 0, w, h, Color( 125, 125, 125, 55 ) )
                    draw.RoundedBox( 6, 1, 1, w-2, h-2, Color( 16, 8, 21, 225 ) )
                end

                local mdl = ( ( t.model and t.model ) or item.WorldModel or "models/items/item_item_crate.mdl" )
                local DModelPanel = self:DModelPanel( DButton, mdl )
                DModelPanel:Dock( FILL )
                DModelPanel:SetWide( H*.14 )
                DModelPanel:SetFOV( (w/1920) * 54 )
                DModelPanel.PaintOver = function( s, w, h )
                    if !s:IsHovered() then return end
                    draw.SimpleText( t.name, "vs.mining.ui.14", w/2, h*.9, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end
                DModelPanel.DoClick = function()
                    selectedCraftable = k
                    timer.Create( "vs_mining.orerequirement", 0, 1, ores )
                end
            end
        end
        timer.Simple( 0, function() populate() end )
    end

    local Mining_Pages = {}
    Mining_Pages[ "home" ] = { name = "Home", color = Color( 200, 100, 200, 155 ), func = Miningsystem_home, }
    Mining_Pages[ "craft" ] = { name = "Crafting", color = Color( 200, 200, 100, 155 ), func = Miningsystem_crafting, }

    local tab = {}
    for k, v in SortedPairs( Mining_Pages, true ) do
        local name = v.name
        local color = v.color

        local DButton = vgui.Create( "DButton", DNavbar )
        tab[k] = DButton
        DButton:Dock( LEFT )
        DButton:DockMargin( 0, 0, W*.005, 0 )
        DButton:SetWide( W*.1 )
        DButton:SetText( "" )
        DButton.DoClick = function( s )
			if !v.func then return end
            if _selectedTab == s then return end
			loadPanel( s, v.func )
            surface.PlaySound( "UI/buttonclick.wav" )
		end
        DButton.Paint = function( s, w, h )
            if _selectedTab == s or s:IsHovered() then
                s.lerpGradient = Lerp( FrameTime() * 5, s.lerpGradient or 0, h*.85 )
                s.lerpRect = Lerp( FrameTime() * 14, s.lerpRect or 0, h )
                s.lerpLine = Lerp( FrameTime() * 8, s.lerpLine or 0, w )
                surface.SetDrawColor( color or color_white )
                surface.SetMaterial( gradientDown )
                surface.DrawTexturedRect( w*.035, H*.004, w*.946, s.lerpGradient )

                surface.DrawOutlinedRect( 0, 0, w, s.lerpRect )
                surface.DrawRect( 0, h-2, s.lerpLine, 2 )
            else
                s.lerpGradient = false
                s.lerpRect = false
                s.lerpLine = false
            end
            draw.SimpleText( name, "vs.mining.ui.28", w/2, h/2, ( s:IsHovered() and color_white or Color( 255, 255, 255, 155 ) ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )
        end
    end
    loadPanel( tab["home"], Miningsystem_home )

    self.Background:ShowCloseButton( false ) -- very cool
end
concommand.Add( "vs.mining_ui", function( p ) VectivusMining:NpcMenu( p ) end )