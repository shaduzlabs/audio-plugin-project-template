
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #######

# http://stackoverflow.com/questions/26182289/convert-from-decimal-to-hexadecimal-in-cmake

# --------------------------------------------------------------------------------------------------

macro(hexChar2dec VAR VAL)
    if (${VAL} MATCHES "[0-9]")
        set(${VAR} ${VAL})
    elseif(${VAL} MATCHES "[aA]")
        set(${VAR} 10)
    elseif(${VAL} MATCHES "[bB]")
        set(${VAR} 11)
    elseif(${VAL} MATCHES "[cC]")
        set(${VAR} 12)
    elseif(${VAL} MATCHES "[dD]")
        set(${VAR} 13)
    elseif(${VAL} MATCHES "[eE]")
        set(${VAR} 14)
    elseif(${VAL} MATCHES "[fF]")
        set(${VAR} 15)
    else()
        message(FATAL_ERROR "Invalid format for hexidecimal character")
    endif()
endmacro(hexChar2dec)

# --------------------------------------------------------------------------------------------------

macro(hex2dec VAR VAL)
    if (${VAL} EQUAL 0)
        set(${VAR} 0)
    else()

        set(CURINDEX 0)
        string(LENGTH "${VAL}" CURLENGTH)

        set(${VAR} 0)

        while (CURINDEX LESS  CURLENGTH)

            string(SUBSTRING "${VAL}" ${CURINDEX} 1 CHAR)

            hexChar2dec(CHAR ${CHAR})

            math(EXPR POWAH "(1<<((${CURLENGTH}-${CURINDEX}-1)*4))")
            math(EXPR CHAR "(${CHAR}*${POWAH})")
            math(EXPR ${VAR} "${${VAR}}+${CHAR}")
            math(EXPR CURINDEX "${CURINDEX}+1")
        endwhile()
    endif()
endmacro(hex2dec)

# --------------------------------------------------------------------------------------------------

macro(decChar2hex VAR VAL)
    if (${VAL} LESS 10)
        set(${VAR} ${VAL})
    elseif(${VAL} EQUAL 10)
        set(${VAR} "A")
    elseif(${VAL} EQUAL 11)
        set(${VAR} "B")
    elseif(${VAL} EQUAL 12)
        set(${VAR} "C")
    elseif(${VAL} EQUAL 13)
        set(${VAR} "D")
    elseif(${VAL} EQUAL 14)
        set(${VAR} "E")
    elseif(${VAL} EQUAL 15)
        set(${VAR} "F")
    else()
        message(FATAL_ERROR "Invalid format for hexidecimal character")
    endif()
endmacro(decChar2hex)

# --------------------------------------------------------------------------------------------------

macro(dec2hex VAR VAL)
    if (${VAL} EQUAL 0)
        set(${VAR} 0)
    else()
        set(VAL2 ${VAL})
        set(${VAR} "")

        while (${VAL2} GREATER 0)
            math(EXPR VALCHAR "(${VAL2}&15)")
            decChar2hex(VALCHAR ${VALCHAR})
            set(${VAR} "${VALCHAR}${${VAR}}")
            math(EXPR VAL2 "${VAL2} >> 4")
        endwhile()
    endif()
endmacro(dec2hex)
