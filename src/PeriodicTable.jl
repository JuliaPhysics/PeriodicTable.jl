module PeriodicTable

# Import modules
using JSON

# constants
const DATA_FILE = "elements.json"
const PACKAGE_NAME = "PeriodicTable"

"""
Element composite type
"""
type Element
    data
    name    
    appearance
    atomic_mass
    boil
    category
    color
    density
    discovered_by
    melt
    molar_heat
    named_by
    number
    period
    phase
    source
    spectral_img
    summary
    symbol
    xpos
    ypos
    shells

    # inner constructor
    Element(data,
            name            = get(data, "name", nothing),  
            appearance      = get(data, "appearance", nothing), 
            atomic_mass     = get(data, "atomic_mass", nothing), 
            boil            = get(data, "boil", nothing), 
            category        = get(data, "category", nothing), 
            color           = get(data, "color", nothing), 
            density         = get(data, "density", nothing), 
            discovered_by   = get(data, "discovered_by", nothing), 
            melt            = get(data, "melt", nothing), 
            molar_heat      = get(data, "molar_heat", nothing), 
            named_by        = get(data, "named_by", nothing), 
            number          = get(data, "number", nothing), 
            period          = get(data, "period", nothing), 
            phase           = get(data, "phase", nothing), 
            source          = get(data, "source", nothing), 
            spectral_img    = get(data, "spectral_img", nothing), 
            summary         = get(data, "summary", nothing), 
            symbol          = get(data, "symbol", nothing), 
            xpos            = get(data, "xpos", nothing), 
            ypos            = get(data, "ypos", nothing), 
            shells          = get(data, "shells", nothing)) = new(data,name,appearance,atomic_mass,
                                                                boil,category,color,density,
                                                                discovered_by,melt,molar_heat,
                                                                named_by,number,period,phase,source,
                                                                spectral_img,summary,symbol,
                                                                xpos,ypos,shells)
end


"""
PT composite type 
"""
type PT
    data

    # Helper method, something that I am happy it worked!
    function load_data()
        output = []
        file_path = joinpath(Pkg.dir(PACKAGE_NAME),"src","data", DATA_FILE)
        
        # open the file, convert data, append to Array
        open(file_path, "r") do file
        data_json = JSON.parse(readstring(file))
        for d in data_json
            push!(output, Element(d))
        end
        end
        
        output
    end
    
    # inner constructor
    function PT()
        data = load_data()
        new(data)
    end
end


"""
Function to get element by atomic number
"""
function get_element(pt::PT, atomic_number::Int64)
    pt.data[atomic_number]
end
    

"""
Show table
"""
function Base.show(io::IO, ::MIME"text/plain", p::PT) #We can make this static if data is loaded in compile time
    table_length = length(p.data)
    shape = (10,18)
    
    array_table = fill("   ", shape)
    for i in 1:table_length
        el = p.data[i].data
        array_table[el["ypos"], el["xpos"]] = rpad(el["symbol"], 3)
    end
    print(join([join(array_table[i,:]) for i in 1:shape[1]], '\n'))
end


# exports
export Element, PT, get_element

end
