/****************************************************************************
** Meta object code from reading C++ file 'audiooutput.h'
**
** Created: Tue Aug 9 19:09:21 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "audiooutput.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'audiooutput.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Generator[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

       0        // eod
};

static const char qt_meta_stringdata_Generator[] = {
    "Generator\0"
};

const QMetaObject Generator::staticMetaObject = {
    { &QIODevice::staticMetaObject, qt_meta_stringdata_Generator,
      qt_meta_data_Generator, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Generator::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Generator::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Generator::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Generator))
        return static_cast<void*>(const_cast< Generator*>(this));
    return QIODevice::qt_metacast(_clname);
}

int Generator::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QIODevice::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
static const uint qt_meta_data_AudioTest[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      10,   19,   19,   19, 0x08,
      20,   19,   19,   19, 0x08,
      32,   19,   19,   19, 0x08,
      41,   19,   19,   19, 0x08,
      54,   75,   19,   19, 0x08,
      77,   96,   19,   19, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_AudioTest[] = {
    "AudioTest\0status()\0\0writeMore()\0"
    "toggle()\0togglePlay()\0state(QAudio::State)\0"
    "s\0deviceChanged(int)\0idx\0"
};

const QMetaObject AudioTest::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_AudioTest,
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
    return QMainWindow::qt_metacast(_clname);
}

int AudioTest::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: status(); break;
        case 1: writeMore(); break;
        case 2: toggle(); break;
        case 3: togglePlay(); break;
        case 4: state((*reinterpret_cast< QAudio::State(*)>(_a[1]))); break;
        case 5: deviceChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 6;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
