
import 'package:cloud_firestore/cloud_firestore.dart';




String formatDate(Timestamp t, double offset){
        DateTime d = t.toDate();
        print("ggyo"+offset.toString());
        if(offset<0)
        {offset = offset*(-1);
        Duration o = Duration(minutes: (offset*60).round());
        d = d.subtract(o);}
        else{
                Duration o = Duration(minutes: (offset*60).round());
                d = d.add(o);
        }
        String formattedDate = d.toString();
        return formattedDate;
}


Map<String, double> time_zones = {
        'Pacific/ Honolulu': -10,
        'America/Juneau': -9,
        'America/Tijuana': -8,
        'America/Boise': -7,
        'America/Chihuahua': -7,
        'America/Phoenix': -7,
        'America/Chicago': -6,
        'America/Regina': -6,
        'America/Mexico_City': -6,
        'America/Belize': -6,
        'America/Detroit': -5,
        'America/Bogota': -5,
        'America/Caracas': -4,
        'America/St_Johns': -3.50,
        'America/Sao_Paulo': -3,
        'America/Argentina/Buenos_Aires': -3,
        'America/Godthab': -3,
        'Atlantic/Azores': -1,
        'Atlantic/Cape_Verde': -1,
        'GMT': 0,
        'Africa/Casablanca': 0,
        'Atlantic/Canary': 0,
        'Europe/Belgrade': 1,
        'Europe/Sarajevo': 1,
        'Europe/Brussels': 1,
        'Europe/Amsterdam': 1,
        'Africa/Algiers': 1,
        'Europe/Bucharest': 2,
        'Africa/Cairo': 2,
        'Europe/Helsinki': 2,
        'Europe/Athens': 2,
        'Asia/Jerusalem': 2,
        'Africa/Harare': 2,
        'Europe/Moscow': 3,
        'Asia/Kuwait': 3,
        'Africa/Nairobi': 3,
        'Asia/Baghdad': 3,
        'Asia/Tehran': 3.5,
        'Asia/Dubai': 4,
        'Asia/Baku': 4.5,
        'Asia/Kabul': 4.5,
        'Asia/Yekaterinburg': 5,
        'Asia/Karachi': 5,
        'Asia/Kolkata': 5.5,
        'Asia/Kathmandu': 5.75,
        'Asia/Dhaka': 6,
        'Asia/Colombo': 5.5,
        'Asia/Almaty': 6,
        'Asia/Rangoon': 6.5,
        'Asia/Bangkok': 7,
        'Asia/Krasnoyarsk': 7,
        'Asia/Shanghai': 8,
        'Asia/Kuala_Lumpur': 8,
        'Asia/Taipei': 8,
        'Australia/Perth': 8,
        'Asia/Irkutsk': 8,
        'Asia/Seoul': 9,
        'Asia/Tokyo': 9,
        'Asia/Yakutsk': 10,
        'Australia/Darwin': 9.5,
        'Australia/Adelaide': 10.5,
        'Australia/Sydney': 11,
        'Australia/Brisbane': 10,
        'Australia/Hobart': 11,
        'Asia/Vladivostok': 10,
        'Pacific/Guam': 10,
        'Asia/Magadan': 11,
        'Pacific/Fiji': 13,
        'Pacific/Auckland': 13,
        'Pacific/Tongatapu': 14,
    };