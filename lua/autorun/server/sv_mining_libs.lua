// DATA SAVING & LOADING //
function VectivusMining:ParseKey( k )
    local a = string.lower( k )
    a = string.Replace( a, ":", "_" )
    return a
end

function VectivusMining:SaveData( sid, name, data, bool ) // sid, filename, data, istable(bool)
    local a = self:ParseKey( sid )
    file.CreateDir( "vs_mining" )
    file.CreateDir( "vs_mining/" .. a )
    local path = ( "vs_mining/" .. a .. "/" )
    path = ( path .. name .. ".dat" )
    file.Write( path, ( bool and util.TableToJSON( data, true ) or data ) )
end

function VectivusMining:LoadData( sid, name, bool ) // sid, filename, istable(bool)
    local a = self:ParseKey( sid )
    local path = ( "vs_mining/" .. a .. "/" )
    path = ( path .. name .. ".dat" )
    if file.Exists( path, "DATA" ) then
        local r = file.Read( path, "DATA" )
        return ( bool and util.JSONToTable( r ) or r )
    end
    return false
end
// DATA SAVING & LOADING //


// chat.AddText ( sv kinda ) //
util.AddNetworkString( "VectivusMining.Chat" )
function VectivusMining:AddText( p, txt )
    if !IsValid( p ) then return end
    if !txt then return end
    net.Start( "VectivusMining.Chat" )
        net.WriteString( txt )
    net.Send( p )
end
// chat.AddText ( sv kinda ) // 