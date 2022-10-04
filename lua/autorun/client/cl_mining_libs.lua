// FONTS //
function VectivusMining:CreateFont( name, size, bold )
    if !name then print( "VectivusMining:CreateFont", "missing argument #1 (string name)" ) return end
    if !size then print( "VectivusMining:CreateFont", "missing argument #2 (int size)" ) return end
    bold = ( bold and 1024 or 0 )
    surface.CreateFont( name, { font = "Purista", size = size, weight = bold, } )
end

for i=14, 28 do VectivusMining:CreateFont( "vs.mining.ui."..i, i ) end
VectivusMining:CreateFont( "vs.mining.ui.35", 35 )
VectivusMining:CreateFont( "vs.mining.ui.50", 50 )
// FONTS //


// DPanel //
function VectivusMining:DPanel( parent ) // parent
    if !IsValid( parent ) then print( "VectivusMining:DPanel", "missing argument #1 (Panel parent)" ) return end
    local DPanel = vgui.Create( "DPanel", parent )
    DPanel.Paint = function( s, w, h )
        draw.RoundedBox( 4, 0, 0, w, h, Color( 125, 125, 125, 55 ), false, false, true, true )
        draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 16, 8, 21, 225 ), false, false, true, true )
    end
    return DPanel
end
// DPanel //


// DScrollPanel //
function VectivusMining:DScrollPanel( parent ) // parent
    if !IsValid( parent ) then print( "VectivusMining:ScrollPanel", "missing argument #1 (Panel parent)" ) return end
    local DScrollPanel = vgui.Create( "DScrollPanel", parent )
    local sbar = DScrollPanel:GetVBar()
    local bb = 0
    sbar.btnUp.Paint = function( _, w, h ) bb = h end
    sbar.Paint = function( _, w, h )
        draw.RoundedBox( 16, w / 4 - w / 4, bb, w / 4, h - bb * 2, Color( 0, 0, 0, 128 ) )
    end sbar.btnDown.Paint = nil
    sbar.btnGrip.Paint = function( s, w, h )
        if s:IsHovered() then
            draw.RoundedBox( 16, w / 4 - w / 4, 0, w / 4, h, Color( 187, 64, 156, 166 ) )
        else
            draw.RoundedBox( 16, w / 4 - w / 4, 0, w / 4, h, Color( 187, 64, 156, 88 ) )
        end
    end
    return DScrollPanel
end
// DScrollPanel //


// DModelPanel //
function VectivusMining:DModelPanel( parent, model )
    if !IsValid( parent ) then print( "VectivusMining:DModelPanel", "missing argument #1 (Panel parent)" ) return end

    local DModelPanel = vgui.Create( "DModelPanel", parent )
    DModelPanel:SetModel( model or "" )
    DModelPanel:SetText( "" )
    DModelPanel.Think = function( s )
        s:SetModel( model ) 
    end
    if DModelPanel.Entity then
        DModelPanel.Entity:SetPos( DModelPanel.Entity:GetPos() - Vector( 0, 0, -4 ) )
        local num = .7
        local min, max = DModelPanel.Entity:GetRenderBounds()
        DModelPanel:SetCamPos( min:Distance( max ) * Vector( num, num, num ) )
        DModelPanel:SetLookAt( (max + min) / 2 )
    end
    function DModelPanel:LayoutEntity( e ) return end 
    return DModelPanel
end
// DModelPanel //