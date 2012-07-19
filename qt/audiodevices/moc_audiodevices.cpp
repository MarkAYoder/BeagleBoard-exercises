/****************************************************************************
** Meta object code from reading C++ file 'audiodevices.h'
**
** Created: Tue Aug 9 18:59:18 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "audiodevices.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'audiodevices.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_AudioTest[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      10,   27,   31,   31, 0x08,
      32,   27,   31,   31, 0x08,
      51,   27,   31,   31, 0x08,
      68,   27,   31,   31, 0x08,
      88,   27,   31,   31, 0x08,
     106,   27,   31,   31, 0x08,
     129,   27,   31,   31, 0x08,
     152,   27,   31,   31, 0x08,
     171,   31,   31,   31, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_AudioTest[] = {
    "AudioTest\0modeChanged(int)\0idx\0\0"
    "deviceChanged(int)\0freqChanged(int)\0"
    "channelChanged(int)\0codecChanged(int)\0"
    "sampleSizeChanged(int)\0sampleTypeChanged(int)\0"
    "endianChanged(int)\0test()\0"
};

const QMetaObject AudioTest::staticMetaObject = {
    { &AudioDevicesBase::staticMetaObject, qt_meta_stringdata_AudioTest,
      qt_meta_data_AudioTest, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &AudioTest::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *AudioTest::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *AudioTest::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_AudioTest))
        return static_cast<void*>(const_cast< AudioTest*>(this));
    return AudioDevicesBase::qt_metacast(_clname);
}

int AudioTest::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = AudioDevicesBase::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: modeChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: deviceChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 2: freqChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 3: channelChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 4: codecChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 5: sampleSizeChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 6: sampleTypeChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 7: endianChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 8: test(); break;
        default: ;
        }
        _id -= 9;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
