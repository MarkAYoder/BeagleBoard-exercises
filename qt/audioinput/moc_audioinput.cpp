/****************************************************************************
** Meta object code from reading C++ file 'audioinput.h'
**
** Created: Tue Aug 9 19:18:12 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "audioinput.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'audioinput.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_AudioInfo[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      10,   19,   19,   19, 0x05,

       0        // eod
};

static const char qt_meta_stringdata_AudioInfo[] = {
    "AudioInfo\0update()\0\0"
};

const QMetaObject AudioInfo::staticMetaObject = {
    { &QIODevice::staticMetaObject, qt_meta_stringdata_AudioInfo,
      qt_meta_data_AudioInfo, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &AudioInfo::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *AudioInfo::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *AudioInfo::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_AudioInfo))
        return static_cast<void*>(const_cast< AudioInfo*>(this));
    return QIODevice::qt_metacast(_clname);
}

int AudioInfo::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QIODevice::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: update(); break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}

// SIGNAL 0
void AudioInfo::update()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}
static const uint qt_meta_data_RenderArea[] = {

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

static const char qt_meta_stringdata_RenderArea[] = {
    "RenderArea\0"
};

const QMetaObject RenderArea::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_RenderArea,
      qt_meta_data_RenderArea, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &RenderArea::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *RenderArea::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *RenderArea::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_RenderArea))
        return static_cast<void*>(const_cast< RenderArea*>(this));
    return QWidget::qt_metacast(_clname);
}

int RenderArea::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
static const uint qt_meta_data_InputTest[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      10,   27,   27,   27, 0x08,
      28,   27,   27,   27, 0x08,
      37,   27,   27,   27, 0x08,
      48,   27,   27,   27, 0x08,
      61,   27,   27,   27, 0x08,
      77,   98,   27,   27, 0x08,
     100,  119,   27,   27, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_InputTest[] = {
    "InputTest\0refreshDisplay()\0\0status()\0"
    "readMore()\0toggleMode()\0toggleSuspend()\0"
    "state(QAudio::State)\0s\0deviceChanged(int)\0"
    "idx\0"
};

const QMetaObject InputTest::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_InputTest,
      qt_meta_data_InputTest, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &InputTest::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *InputTest::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *InputTest::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_InputTest))
        return static_cast<void*>(const_cast< InputTest*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int InputTest::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: refreshDisplay(); break;
        case 1: status(); break;
        case 2: readMore(); break;
        case 3: toggleMode(); break;
        case 4: toggleSuspend(); break;
        case 5: state((*reinterpret_cast< QAudio::State(*)>(_a[1]))); break;
        case 6: deviceChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 7;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
