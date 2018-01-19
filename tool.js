'use strict'

import { NativeModules } from 'react-native'
const { Boilerplate } = NativeModules;
class MyToast {
    show(message) {
        return Boilerplate.show(message);
    }
}
export default new MyToast();