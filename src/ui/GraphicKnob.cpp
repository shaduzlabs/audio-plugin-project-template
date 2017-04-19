/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#include "GraphicKnob.h"

//--------------------------------------------------------------------------------------------------

GraphicKnob::GraphicKnob(const Image& image_, unsigned nFrames_, bool horizontal_)
  : m_imageBackground(image_)
  , m_nFrames(nFrames_)
  , m_horizontal(horizontal_)
  , m_frameWidth(horizontal_ ? (image_.getWidth() / nFrames_) : image_.getWidth())
  , m_frameHeight(horizontal_ ? image_.getHeight() : (image_.getHeight() / nFrames_))
  , m_imageBackgroundHover{nullptr}
{
  setSliderStyle(Slider::RotaryVerticalDrag);
  setTextBoxStyle(NoTextBox, 0, 0, 0);
  setName("Graphic knob");
  setSize(m_frameWidth, m_frameHeight);
}

//--------------------------------------------------------------------------------------------------

void GraphicKnob::paint(Graphics& g)
{
  int value = (getValue() - getMinimum()) / (getMaximum() - getMinimum()) * (m_nFrames - 1);
  if (m_imageBackgroundHover != nullptr && isEnabled() && isMouseOverOrDragging())
  {
    g.drawImage(
      *m_imageBackgroundHover, 0, 0, getWidth(), getHeight(), 0, 0, m_frameWidth, m_frameHeight);
  }

  if (m_horizontal)
  {
    g.drawImage(m_imageBackground,
      0,
      0,
      getWidth(),
      getHeight(),
      value * m_frameWidth,
      0,
      m_frameWidth,
      m_frameHeight);
  }
  else
  {
    g.drawImage(m_imageBackground,
      0,
      0,
      getWidth(),
      getHeight(),
      0,
      value * m_frameHeight,
      m_frameWidth,
      m_frameHeight);
  }
}

//--------------------------------------------------------------------------------------------------

void GraphicKnob::resized()
{
}
