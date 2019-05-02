-- a type template manager

namespace typer

public integer YES=1, NO=0

sequence types = {{},{}}

function float(object o)
    return atom(o) and not integer(o)
end function

function seq_of_atoms(object a)
    if sequence(a) then
        for t=1 to length(a) do
            if sequence(a[t]) then
                return false
            end if
        end for
    else
        return false
    end if
    return true
end function

public procedure add_template(string tname, object tmp)
integer i = find(tname,types[1])
    if i > 0 then
        types[2][i] = tmp
    else
        types[1] = append(types[1],tname)
        types[2] = append(types[2],tmp)
    end if
end procedure

integer Verbose = NO
public procedure verbose(integer i)
    Verbose = i
end procedure

function hasSameStructure(object a, object b)
    if Verbose = YES then
        ?{a,b}
    end if
    if integer(a) and integer(b) then
        return true
    elsif atom(a) and atom(b) then
        if not integer(a) and not integer(b) then
            return true
        end if
    elsif sequence(a) and sequence(b) then
--      if string(a) and string(b) then -- Phix catches strings better than Euphoria
        if seq_of_atoms(a) and seq_of_atoms(b) then
            return true
        else
            if length(a) != length(b) then
                return false
            end if
            for t=1 to length(a) do
                if not hasSameStructure(a[t],b[t]) then
                    return false
                end if
            end for
            return true
        end if
    end if
    return false
end function

public function is(string tname, object var)
integer i = find(tname,types[1])
    if i > 0 then
        object this = types[2][i]
        return hasSameStructure(var,this)
    end if
    return false
end function

