/****************************************************************************
** Meta object code from reading C++ file 'videoplayer.h'
**
** Created: Tue Aug 9 19:24:55 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "videoplayer.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'videoplayer.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_VideoPlayer[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      12,   23,   23,   23, 0x0a,
      24,   23,   23,   23, 0x0a,
      31,   69,   23,   23, 0x08,
      75,   93,   23,   23, 0x08,
      99,   93,   23,   23, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_VideoPlayer[] = {
    "VideoPlayer\0openFile()\0\0play()\0"
    "movieStateChanged(QMovie::MovieState)\0"
    "state\0frameChanged(int)\0frame\0"
    "setPosition(int)\0"
};

const QMetaObject VideoPlayer::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_VideoPlayer,
      qt_meta_data_VideoPlayer, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &VideoPlayer::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *VideoPlayer::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *VideoPlayer::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_VideoPlayer))
        return static_cast<void*>(const_cast< VideoPlayer*>(this));
    return QWidget::qt_metacast(_clname);
}

int VideoPlayer::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: openFile(); break;
        case 1: play(); break;
        case 2: movieStateChanged((*reinterpret_cast< QMovie::MovieState(*)>(_a[1]))); break;
        case 3: frameChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 4: setPosition((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 5;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
