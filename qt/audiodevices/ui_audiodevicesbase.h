/********************************************************************************
** Form generated from reading UI file 'audiodevicesbase.ui'
**
** Created: Tue Aug 9 18:58:31 2011
**      by: Qt User Interface Compiler version 4.6.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_AUDIODEVICESBASE_H
#define UI_AUDIODEVICESBASE_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QComboBox>
#include <QtGui/QGridLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QMainWindow>
#include <QtGui/QPushButton>
#include <QtGui/QStatusBar>
#include <QtGui/QTextEdit>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_AudioDevicesBase
{
public:
    QWidget *centralwidget;
    QVBoxLayout *verticalLayout;
    QGridLayout *gridLayout;
    QLabel *deviceLabel;
    QLabel *modeLabel;
    QComboBox *deviceBox;
    QComboBox *modeBox;
    QLabel *actualLabel;
    QLabel *nearestLabel;
    QLabel *actualFreqLabel;
    QLabel *nearestFreqLabel;
    QComboBox *frequencyBox;
    QLineEdit *nearestFreq;
    QLabel *actualChannelsLabel;
    QLabel *nearestChannelLabel;
    QComboBox *channelsBox;
    QLineEdit *nearestChannel;
    QLabel *actualCodecLabel;
    QLabel *nearestCodecLabel;
    QComboBox *codecsBox;
    QLineEdit *nearestCodec;
    QLabel *actualSampleSizeLabel;
    QLabel *nearestSampleSizeLabel;
    QComboBox *sampleSizesBox;
    QLineEdit *nearestSampleSize;
    QLabel *actualSampleTypeLabel;
    QLabel *nearestSampleTypeLabel;
    QComboBox *sampleTypesBox;
    QLineEdit *nearestSampleType;
    QLabel *actualEndianLabel;
    QLabel *nearestEndianLabel;
    QComboBox *endianBox;
    QLineEdit *nearestEndian;
    QTextEdit *logOutput;
    QPushButton *testButton;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *AudioDevicesBase)
    {
        if (AudioDevicesBase->objectName().isEmpty())
            AudioDevicesBase->setObjectName(QString::fromUtf8("AudioDevicesBase"));
        AudioDevicesBase->resize(504, 702);
        centralwidget = new QWidget(AudioDevicesBase);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        verticalLayout = new QVBoxLayout(centralwidget);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        gridLayout = new QGridLayout();
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        deviceLabel = new QLabel(centralwidget);
        deviceLabel->setObjectName(QString::fromUtf8("deviceLabel"));
        QSizePolicy sizePolicy(QSizePolicy::Preferred, QSizePolicy::Preferred);
        sizePolicy.setHorizontalStretch(1);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(deviceLabel->sizePolicy().hasHeightForWidth());
        deviceLabel->setSizePolicy(sizePolicy);

        gridLayout->addWidget(deviceLabel, 0, 0, 1, 1);

        modeLabel = new QLabel(centralwidget);
        modeLabel->setObjectName(QString::fromUtf8("modeLabel"));

        gridLayout->addWidget(modeLabel, 0, 1, 1, 1);

        deviceBox = new QComboBox(centralwidget);
        deviceBox->setObjectName(QString::fromUtf8("deviceBox"));

        gridLayout->addWidget(deviceBox, 1, 0, 1, 1);

        modeBox = new QComboBox(centralwidget);
        modeBox->setObjectName(QString::fromUtf8("modeBox"));

        gridLayout->addWidget(modeBox, 1, 1, 1, 1);

        actualLabel = new QLabel(centralwidget);
        actualLabel->setObjectName(QString::fromUtf8("actualLabel"));
        actualLabel->setFrameShape(QFrame::Panel);
        actualLabel->setFrameShadow(QFrame::Raised);
        actualLabel->setAlignment(Qt::AlignCenter);

        gridLayout->addWidget(actualLabel, 2, 0, 1, 1);

        nearestLabel = new QLabel(centralwidget);
        nearestLabel->setObjectName(QString::fromUtf8("nearestLabel"));
        nearestLabel->setFrameShape(QFrame::Panel);
        nearestLabel->setFrameShadow(QFrame::Raised);
        nearestLabel->setAlignment(Qt::AlignCenter);

        gridLayout->addWidget(nearestLabel, 2, 1, 1, 1);

        actualFreqLabel = new QLabel(centralwidget);
        actualFreqLabel->setObjectName(QString::fromUtf8("actualFreqLabel"));

        gridLayout->addWidget(actualFreqLabel, 3, 0, 1, 1);

        nearestFreqLabel = new QLabel(centralwidget);
        nearestFreqLabel->setObjectName(QString::fromUtf8("nearestFreqLabel"));

        gridLayout->addWidget(nearestFreqLabel, 3, 1, 1, 1);

        frequencyBox = new QComboBox(centralwidget);
        frequencyBox->setObjectName(QString::fromUtf8("frequencyBox"));

        gridLayout->addWidget(frequencyBox, 4, 0, 1, 1);

        nearestFreq = new QLineEdit(centralwidget);
        nearestFreq->setObjectName(QString::fromUtf8("nearestFreq"));
        nearestFreq->setEnabled(false);

        gridLayout->addWidget(nearestFreq, 4, 1, 1, 1);

        actualChannelsLabel = new QLabel(centralwidget);
        actualChannelsLabel->setObjectName(QString::fromUtf8("actualChannelsLabel"));

        gridLayout->addWidget(actualChannelsLabel, 5, 0, 1, 1);

        nearestChannelLabel = new QLabel(centralwidget);
        nearestChannelLabel->setObjectName(QString::fromUtf8("nearestChannelLabel"));

        gridLayout->addWidget(nearestChannelLabel, 5, 1, 1, 1);

        channelsBox = new QComboBox(centralwidget);
        channelsBox->setObjectName(QString::fromUtf8("channelsBox"));

        gridLayout->addWidget(channelsBox, 6, 0, 1, 1);

        nearestChannel = new QLineEdit(centralwidget);
        nearestChannel->setObjectName(QString::fromUtf8("nearestChannel"));
        nearestChannel->setEnabled(false);

        gridLayout->addWidget(nearestChannel, 6, 1, 1, 1);

        actualCodecLabel = new QLabel(centralwidget);
        actualCodecLabel->setObjectName(QString::fromUtf8("actualCodecLabel"));

        gridLayout->addWidget(actualCodecLabel, 7, 0, 1, 1);

        nearestCodecLabel = new QLabel(centralwidget);
        nearestCodecLabel->setObjectName(QString::fromUtf8("nearestCodecLabel"));

        gridLayout->addWidget(nearestCodecLabel, 7, 1, 1, 1);

        codecsBox = new QComboBox(centralwidget);
        codecsBox->setObjectName(QString::fromUtf8("codecsBox"));

        gridLayout->addWidget(codecsBox, 8, 0, 1, 1);

        nearestCodec = new QLineEdit(centralwidget);
        nearestCodec->setObjectName(QString::fromUtf8("nearestCodec"));
        nearestCodec->setEnabled(false);

        gridLayout->addWidget(nearestCodec, 8, 1, 1, 1);

        actualSampleSizeLabel = new QLabel(centralwidget);
        actualSampleSizeLabel->setObjectName(QString::fromUtf8("actualSampleSizeLabel"));

        gridLayout->addWidget(actualSampleSizeLabel, 9, 0, 1, 1);

        nearestSampleSizeLabel = new QLabel(centralwidget);
        nearestSampleSizeLabel->setObjectName(QString::fromUtf8("nearestSampleSizeLabel"));

        gridLayout->addWidget(nearestSampleSizeLabel, 9, 1, 1, 1);

        sampleSizesBox = new QComboBox(centralwidget);
        sampleSizesBox->setObjectName(QString::fromUtf8("sampleSizesBox"));

        gridLayout->addWidget(sampleSizesBox, 10, 0, 1, 1);

        nearestSampleSize = new QLineEdit(centralwidget);
        nearestSampleSize->setObjectName(QString::fromUtf8("nearestSampleSize"));
        nearestSampleSize->setEnabled(false);

        gridLayout->addWidget(nearestSampleSize, 10, 1, 1, 1);

        actualSampleTypeLabel = new QLabel(centralwidget);
        actualSampleTypeLabel->setObjectName(QString::fromUtf8("actualSampleTypeLabel"));

        gridLayout->addWidget(actualSampleTypeLabel, 11, 0, 1, 1);

        nearestSampleTypeLabel = new QLabel(centralwidget);
        nearestSampleTypeLabel->setObjectName(QString::fromUtf8("nearestSampleTypeLabel"));

        gridLayout->addWidget(nearestSampleTypeLabel, 11, 1, 1, 1);

        sampleTypesBox = new QComboBox(centralwidget);
        sampleTypesBox->setObjectName(QString::fromUtf8("sampleTypesBox"));

        gridLayout->addWidget(sampleTypesBox, 12, 0, 1, 1);

        nearestSampleType = new QLineEdit(centralwidget);
        nearestSampleType->setObjectName(QString::fromUtf8("nearestSampleType"));
        nearestSampleType->setEnabled(false);

        gridLayout->addWidget(nearestSampleType, 12, 1, 1, 1);

        actualEndianLabel = new QLabel(centralwidget);
        actualEndianLabel->setObjectName(QString::fromUtf8("actualEndianLabel"));

        gridLayout->addWidget(actualEndianLabel, 13, 0, 1, 1);

        nearestEndianLabel = new QLabel(centralwidget);
        nearestEndianLabel->setObjectName(QString::fromUtf8("nearestEndianLabel"));

        gridLayout->addWidget(nearestEndianLabel, 13, 1, 1, 1);

        endianBox = new QComboBox(centralwidget);
        endianBox->setObjectName(QString::fromUtf8("endianBox"));

        gridLayout->addWidget(endianBox, 14, 0, 1, 1);

        nearestEndian = new QLineEdit(centralwidget);
        nearestEndian->setObjectName(QString::fromUtf8("nearestEndian"));
        nearestEndian->setEnabled(false);

        gridLayout->addWidget(nearestEndian, 14, 1, 1, 1);

        logOutput = new QTextEdit(centralwidget);
        logOutput->setObjectName(QString::fromUtf8("logOutput"));
        logOutput->setEnabled(false);
        logOutput->setMinimumSize(QSize(0, 40));

        gridLayout->addWidget(logOutput, 15, 0, 1, 2);

        testButton = new QPushButton(centralwidget);
        testButton->setObjectName(QString::fromUtf8("testButton"));

        gridLayout->addWidget(testButton, 16, 0, 1, 2);


        verticalLayout->addLayout(gridLayout);

        AudioDevicesBase->setCentralWidget(centralwidget);
        statusbar = new QStatusBar(AudioDevicesBase);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        AudioDevicesBase->setStatusBar(statusbar);

        retranslateUi(AudioDevicesBase);

        QMetaObject::connectSlotsByName(AudioDevicesBase);
    } // setupUi

    void retranslateUi(QMainWindow *AudioDevicesBase)
    {
        AudioDevicesBase->setWindowTitle(QApplication::translate("AudioDevicesBase", "Audio Devices", 0, QApplication::UnicodeUTF8));
        deviceLabel->setText(QApplication::translate("AudioDevicesBase", "Device", 0, QApplication::UnicodeUTF8));
        modeLabel->setText(QApplication::translate("AudioDevicesBase", "Mode", 0, QApplication::UnicodeUTF8));
        modeBox->clear();
        modeBox->insertItems(0, QStringList()
         << QApplication::translate("AudioDevicesBase", "Input", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("AudioDevicesBase", "Output", 0, QApplication::UnicodeUTF8)
        );
        actualLabel->setText(QApplication::translate("AudioDevicesBase", "Actual Settings", 0, QApplication::UnicodeUTF8));
        nearestLabel->setText(QApplication::translate("AudioDevicesBase", "Nearest Settings", 0, QApplication::UnicodeUTF8));
        actualFreqLabel->setText(QApplication::translate("AudioDevicesBase", "Frequency", 0, QApplication::UnicodeUTF8));
        nearestFreqLabel->setText(QApplication::translate("AudioDevicesBase", "Frequency", 0, QApplication::UnicodeUTF8));
        actualChannelsLabel->setText(QApplication::translate("AudioDevicesBase", "Channels", 0, QApplication::UnicodeUTF8));
        nearestChannelLabel->setText(QApplication::translate("AudioDevicesBase", "Channel", 0, QApplication::UnicodeUTF8));
        actualCodecLabel->setText(QApplication::translate("AudioDevicesBase", "Codecs", 0, QApplication::UnicodeUTF8));
        nearestCodecLabel->setText(QApplication::translate("AudioDevicesBase", "Codec", 0, QApplication::UnicodeUTF8));
        actualSampleSizeLabel->setText(QApplication::translate("AudioDevicesBase", "SampleSize", 0, QApplication::UnicodeUTF8));
        nearestSampleSizeLabel->setText(QApplication::translate("AudioDevicesBase", "SampleSize", 0, QApplication::UnicodeUTF8));
        actualSampleTypeLabel->setText(QApplication::translate("AudioDevicesBase", "SampleType", 0, QApplication::UnicodeUTF8));
        nearestSampleTypeLabel->setText(QApplication::translate("AudioDevicesBase", "SampleType", 0, QApplication::UnicodeUTF8));
        actualEndianLabel->setText(QApplication::translate("AudioDevicesBase", "Endianess", 0, QApplication::UnicodeUTF8));
        nearestEndianLabel->setText(QApplication::translate("AudioDevicesBase", "Endianess", 0, QApplication::UnicodeUTF8));
        testButton->setText(QApplication::translate("AudioDevicesBase", "Test", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class AudioDevicesBase: public Ui_AudioDevicesBase {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_AUDIODEVICESBASE_H
