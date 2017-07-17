function gcd(a,b)
	if b ~= 0 then
		return gcd(b, a % b)
	else
		return math.abs(a)
	end
end

function int(f)
    return math.floor(tonumber(f))
end

function ext_euclid(a,b)
    if b == 0 then
        return a,1,0
    end
    
    local d,s,t = ext_euclid(b, a % b)
    local t_ = s - int(a / b) * t
    
    return d,t,t_
end

function find_coprime(eul)
    local r
    repeat
        r = math.random(5, eul)
    until gcd(eul,r) == 1
    return r
end

function rsa(p,q)
    local N = p * q
    local eul = (p - 1) * (q - 1)
    local e = find_coprime(eul)
    local d_,s,t = ext_euclid(eul,e)
    local check = eul * s + e * t
    local d = t % eul
    local check2 = (e * d) % eul
    
    print("check: "..check)
    print("check2: "..check2)
    
    print("-------------------------")
    print("private key: "..e.."#"..N)
    print("public key: "..d.."#"..N)
    
    return e,d,N
end

function pow_mod(x,p,n)
    local temp = x
    for i=2,p do
        temp = temp * x % n
    end
    return temp
end

function rsa_encr(msg, e, N)
    local ret = ""
    for i = 1, #msg do
        local c = msg:sub(i,i)
        local ac = string.byte(c)
        local ec = pow_mod(ac,e,N)
        ret = ret .. ec .. "#"
        
        print(c.."("..ac..") -> "..ec)
    end
    return ret
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function rsa_decr(msg, d, N)
    local ret = ""
    for i,v in ipairs(split(msg:sub(1,-2),"#")) do
        local vn = tonumber(v)
        local dc = pow_mod(vn,d,N)
        local ac = string.char(dc)
        ret = ret .. ac
        
        print(vn.." -> "..dc.."("..ac..")")
    end
    return ret
end

local privateKey,publicKey,N = rsa(3539, 2729)
print("-------------------------")

local myString = "Marvin ist dumm!"
local encrypted = rsa_encr(myString, privateKey, N)
print("Encrypted '"..myString.."' -> "..encrypted)


local decrypted = rsa_decr(encrypted, publicKey, N)
print("Decrypted -> '"..decrypted.."'")