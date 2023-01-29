/*!
    \file    main.c
    \brief   running led
    
*/

#include "gd32f10x.h"
#include "gd32f10x_bpp.h"
#include "systick.h"
#include <stdio.h>

/*!
    \brief      main function
    \param[in]  none
    \param[out] none
    \retval     none
*/
int main(void)
{
    systick_config();
    gd_eval_led_init(LED);

    while(1){
        /* toogle led */
        gd_eval_led_toggle(LED);
        delay_1ms(500);
    }
}
