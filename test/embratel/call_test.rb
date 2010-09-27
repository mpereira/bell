require 'test_helper'

class CallTest < Test::Unit::TestCase
  def row_with_a_missing_field
    [
     '1',
     '1634125644-FRANQUIA 01',
     '04 - LIGACOES DDD PARA CELULARES',
     '11/08/10 A  99/99/99',
     'SCL -SP',
     'CAS -SP',
     '02:56:29 AM',
     '',
     'E',
     '',
     '500',
     'MIN',
     '0.73'
    ]
  end

  def row_with_invalid_number_called
    [
     '1',
     '1634125644-FRANQUIA 01',
     '04 - LIGACOES DDD PARA CELULARES',
     '11/08/10 A  99/99/99',
     '19936928871',
     'SCL -SP',
     'CAS -SP',
     '02:56:29 AM',
     '',
     'E',
     '',
     '500',
     'MIN',
     '0.73'
    ]
  end

  def row_with_invalid_cost
    [
     '1',
     '1634125644-FRANQUIA 01',
     '04 - LIGACOES DDD PARA CELULARES',
     '11/08/10 A  99/99/99',
     '19936928871',
     'SCL -SP',
     'CAS -SP',
     '02:56:29 AM',
     '',
     'E',
     '',
     '500',
     'MIN',
     '.73'
    ]
  end

  def valid_row
    [
     '1',
     '1634125644-FRANQUIA 01',
     '04 - LIGACOES DDD PARA CELULARES',
     '11/08/10 A  99/99/99',
     '1993692887',
     'SCL -SP',
     'CAS -SP',
     '02:56:29 AM',
     '',
     'E',
     '',
     '500',
     'MIN',
     '0.73'
    ]
  end

  def test_call_instantiated_with_a_row_with_a_missing_field
    call = Embratel::Call.new(row_with_a_missing_field)
    assert(!call.valid?)
  end

  def test_call_instantiated_with_a_row_with_invalid_number_called
    call = Embratel::Call.new(row_with_invalid_number_called)
    assert(!call.valid?)
  end

  def test_call_instantiated_with_a_row_with_invalid_cost
    call = Embratel::Call.new(row_with_invalid_cost)
    assert(!call.valid?)
  end

  def test_call_instantiated_with_a_valid_row
    call = Embratel::Call.new(valid_row)
    assert(call.valid?)
    assert_equal(call.id, '1')
    assert_equal(call.caller, '1634125644-FRANQUIA 01')
    assert_equal(call.description, '04 - LIGACOES DDD PARA CELULARES')
    assert_equal(call.date, '11/08/10 A  99/99/99')
    assert_equal(call.number_called, '1993692887')
    assert_equal(call.caller_local, 'SCL -SP')
    assert_equal(call.called_local, 'CAS -SP')
    assert_equal(call.start_time, '02:56:29 AM')
    assert_equal(call.end_time, '')
    assert_equal(call.imp, 'E')
    assert_equal(call.country, '')
    assert_equal(call.quantity, '500')
    assert_equal(call.unit, 'MIN')
    assert_equal(call.cost, '0.73')
  end
end
