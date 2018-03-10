/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#include "GainGUI.h"

#include "resources/GainGUI.cpp"

#include <iomanip>
#include <sstream>

//--------------------------------------------------------------------------------------------------

GainGUI::GainGUI(PluginAudioProcessor& ap_) : m_audioProcessor(ap_)
{
  m_knobStrip = ImageCache::getFromMemory(::knobstrip_png, ::knobstrip_pngSize);
  m_knobStripHover = ImageCache::getFromMemory(::knobhover_png, ::knobhover_pngSize);

  addAndMakeVisible(m_knob = new GraphicKnob(m_knobStrip, 128, false));
  addAndMakeVisible(m_lblGain = new Label("Value", TRANS("1.0")));
  m_lblGain->setFont(Font(11.20f, Font::plain));
  m_lblGain->setJustificationType(Justification::centred);
  m_lblGain->setEditable(false, false, false);
  m_lblGain->setColour(Label::textColourId, Colour(0x8dffffff));
  m_lblGain->setColour(TextEditor::textColourId, Colours::black);
  m_lblGain->setColour(TextEditor::backgroundColourId, Colour(0x00000000));

  m_backgroundImage = ImageCache::getFromMemory(background_png, background_pngSize);

  m_knob->setRange(0., 2.0);
  m_knob->setValue(static_cast<double>(m_audioProcessor.getParameter(0)));
  m_knob->setImageBackgroundHover(&m_knobStripHover);
  m_knob->addListener(this);

  setSize(150, 180);
}

GainGUI::~GainGUI()
{
  m_knob = nullptr;
  m_lblGain = nullptr;
}

//--------------------------------------------------------------------------------------------------

void GainGUI::paint(Graphics& g)
{

  auto gainValue = m_audioProcessor.gain();
  if (static_cast<float>(gainValue) != m_knob->getValue())
  {
    m_knob->setValue(static_cast<float>(gainValue), NotificationType::dontSendNotification);

    std::stringstream ss;
    ss << std::setprecision(3) << gainValue;
    m_lblGain->setText(ss.str(), NotificationType::dontSendNotification);
  }

  g.fillAll(Colours::white);

  g.setColour(Colours::black);
  g.drawImageWithin(m_backgroundImage, 0, 0, 150, 180, RectanglePlacement::centred, false);
}

//--------------------------------------------------------------------------------------------------

void GainGUI::resized()
{
  m_knob->setBounds(35, 67, 80, 80);
  m_lblGain->setBounds(35, 145, 80, 24);
}

//--------------------------------------------------------------------------------------------------

void GainGUI::sliderValueChanged(Slider* sliderThatWasMoved)
{
  if (sliderThatWasMoved == m_knob)
  {
    auto gainValue = m_audioProcessor.gain();
    std::stringstream ss;
    ss << std::setprecision(3) << gainValue;
    m_audioProcessor.setParameterNotifyingHost(
      0, static_cast<float>(sliderThatWasMoved->getValue()));
    m_lblGain->setText(ss.str(), NotificationType::dontSendNotification);
  }
}

//--------------------------------------------------------------------------------------------------
