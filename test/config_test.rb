# frozen_string_literal: true

require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  def setup
    dc = Jekyll::Configuration.from({})
    @resources = Jekyll::Premonition::Resources.new(dc)
  end

  # def teardown; end

  def test_load_defaults
    cfg = @resources.config
    assert_equal(cfg['default']['title'], nil)
    assert_equal(
      cfg['default']['template'],
      "<div class=\"premonition {% if meta.style %}{{meta.style}} {% endif %}{{type}}\">\n" +
      "  <i class=\"{% if meta.fa-icon %}fas {{meta.fa-icon}}{% else %}premonition {{meta.pn-icon}}{% endif %}\"></i>\n" +
      "  <div class=\"content\">\n" +
      "    {% if header %}<p class=\"header\">{{title}}</p>{% endif %}{{content}}\n" +
      "  </div>\n" +
      "</div>\n"
    )
  end

  def test_load_custom_default
    dc = Jekyll::Configuration.from('premonition' => { 'default' => { 'title' => 'my title', 'template' => '<foo>' } })
    r = Jekyll::Premonition::Resources.new(dc)
    cfg = r.config
    assert_equal(cfg['default']['title'], 'my title')
    assert_equal(cfg['default']['template'], '<foo>')
  end

  def test_load_custom_type_full
    dc = Jekyll::Configuration.from('premonition' =>
    {
      'types' => {
        'note' => {
          'template' => '<bar>',
          'default_title' => 'Default title',
          'meta' => {
            'fa-icon' => 'fa-custom',
            'extra' => 'zot'
          }
        }
      }
    })
    r = Jekyll::Premonition::Resources.new(dc)
    cfg = r.config
    assert_equal(cfg['types']['note']['template'], '<bar>')
    assert_equal(cfg['types']['note']['default_title'], 'Default title')
    assert_equal(cfg['types']['note']['meta']['fa-icon'], 'fa-custom')
    assert_equal(cfg['types']['note']['meta']['extra'], 'zot')
  end

  def test_illegal_types_object
    dc = Jekyll::Configuration.from('premonition' =>
    { 'types' => 'string' })
    assert_raise LoadError do
      Jekyll::Premonition::Resources.new(dc)
    end
  end

  def test_illegal_meta_object
    dc = Jekyll::Configuration.from('premonition' =>
    {
      'types' => {
        'note' => {
          'meta' => []
        }
      }
    })
    assert_raise LoadError do
      Jekyll::Premonition::Resources.new(dc)
    end
  end

  def test_illegal_type_id
    dc = Jekyll::Configuration.from('premonition' =>
    { 'types' => { 'No te' => { } } })
    assert_raise LoadError do
      Jekyll::Premonition::Resources.new(dc)
    end
  end
end
