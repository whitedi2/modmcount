﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписБУ = Новый Массив;
	СписБУ.Добавить("РеализацияТоваровУслуг");
	СписБУ.Добавить("ПоступлениеТоваровУслуг");
	СписБУ.Добавить("СписаниеТоваров");
	СписБУ.Добавить("ПередачаТоваров");
	СписБУ.Добавить("ПередачаМатериаловВЭксплуатацию");
	СписБУ.Добавить("СписаниеМатериаловИзЭксплуатации");
	СписБУ.Добавить("ТребованиеНакладная");
	СписБУ.Добавить("ПеремещениеТоваров");
	СписБУ.Добавить("ОперацияБух");
	СписБУ.Добавить("СписаниеСРасчетногоСчета");
	СписБУ.Добавить("ПоступлениеНаРасчетныйСчет");
	СписБУ.Добавить("ПриходныйКассовыйОрдер");
	СписБУ.Добавить("РасходныйКассовыйОрдер");
	СписБУ.Добавить("РегламентнаяОперация");
	СписБУ.Добавить("ОперацияПоЕдиномуНалоговомуСчету");
	СписБУ.Добавить("УведомлениеОбИсчисленныхСуммахНалогов");
	СписБУ.Добавить("НачислениеДивидендов");
	СписБУ.Добавить("ОтчетПроизводстваЗаСмену");
	СписБУ.Добавить("ОтчетОРозничныхПродажах");
	СписБУ.Добавить("РозничнаяПродажа");
	СписБУ.Добавить("ФормированиеЗаписейКнигиПокупок");
	СписБУ.Добавить("ФормированиеЗаписейКнигиПродаж");
	СписБУ.Добавить("СчетФактураВыданный");
	СписБУ.Добавить("СчетФактураПолученный");
	СписБУ.Добавить("АвансовыйОтчет");
	СписБУ.Добавить("ВозвратТоваровПоставщику");
	СписБУ.Добавить("ВозвратТоваровОтПокупателя");
	СписБУ.Добавить("КорректировкаПоступления");
	СписБУ.Добавить("ОприходованиеТоваров");
	СписБУ.Добавить("НачислениеЗарплаты");
	СписБУ.Добавить("ВедомостьНаВыплатуЗарплаты");
	СписБУ.Добавить("ВедомостьНаВыплатуЗарплатыВБанк");
	СписБУ.Добавить("ВедомостьНаВыплатуЗарплатыВКассу");
	СписБУ.Добавить("ПоступлениеИзПереработки");
	СписБУ.Добавить("КорректировкаРеализации");
	СписБУ.Добавить("ПередачаЗадолженностиНаФакторинг");
	СписБУ.Добавить("ПрочиеДокументы");
	СписБУ.Добавить("СчетНаОплатуПокупателю");
	СписБУ.Добавить("ПлатежноеПоручение");
	СписБУ.Добавить("ОтражениеЗарплатыВБухучете");
	СписБУ.Добавить("ПоступлениеНМА");
	СписБУ.Добавить("ИнвентаризацияТоваровНаСкладе");
	Элементы.ТипДокументаБУ.СписокВыбора.ЗагрузитьЗначения(СписБУ);
	Элементы.ТипДокументаБУ.СписокВыбора.СортироватьПоЗначению();
	Элементы.ТипДокументаБУ.РежимВыбораИзСписка = Истина;
	
	УстановитьСоответствие();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаБУПриИзменении(Элемент)
	
	УстановитьСоответствие();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСоответствие()
	
	Элементы.ВидОперацииБУ.Видимость = Ложь;
	
	Если Запись.ТипДокументаБУ = "РеализацияТоваровУслуг" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Реализация");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
		
		Элементы.ВидОперацииБУ.Видимость = Истина;
		Массив = Новый Массив;
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийРеализацияТоваров"));
		ОписаниеТиповНов = Новый ОписаниеТипов(Массив);
		Элементы.ВидОперацииБУ.ОграничениеТипа = ОписаниеТиповНов;
		
	ИначеЕсли Запись.ТипДокументаБУ = "ПоступлениеТоваровУслуг" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ПоступлениеТоваров");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
		
		Элементы.ВидОперацииБУ.Видимость = Истина;
		Массив = Новый Массив;
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийПоступлениеТоваровУслуг"));
		ОписаниеТиповНов = Новый ОписаниеТипов(Массив);
		Элементы.ВидОперацииБУ.ОграничениеТипа = ОписаниеТиповНов;
		
	ИначеЕсли Запись.ТипДокументаБУ = "СписаниеТоваров" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_СписаниеТоваров");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПередачаТоваров" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_СписаниеТоваров");
		СписУУ.Добавить("УЧ_ПеремещениеМатериаловВПроизводство");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
		
		Элементы.ВидОперацииБУ.Видимость = Истина;
		Массив = Новый Массив;
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийПередачаТоваров"));
		ОписаниеТиповНов = Новый ОписаниеТипов(Массив);
		Элементы.ВидОперацииБУ.ОграничениеТипа = ОписаниеТиповНов;
	ИначеЕсли Запись.ТипДокументаБУ = "ПередачаМатериаловВЭксплуатацию" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ПеремещениеМатериаловВПроизводство");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "СписаниеМатериаловИзЭксплуатации" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_СписаниеТоваров");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ТребованиеНакладная" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ПеремещениеМатериаловВПроизводство");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПеремещениеТоваров" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ПеремещениеТоваров");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ОперацияБух" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "СписаниеСРасчетногоСчета" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ДвижениеДС");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПоступлениеНаРасчетныйСчет" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ДвижениеДС");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПриходныйКассовыйОрдер" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ДвижениеДС");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "РасходныйКассовыйОрдер" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ДвижениеДС");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "РегламентнаяОперация" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
		
		Элементы.ВидОперацииБУ.Видимость = Истина;
		Массив = Новый Массив;
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыРегламентныхОпераций"));
		ОписаниеТиповНов = Новый ОписаниеТипов(Массив);
		Элементы.ВидОперацииБУ.ОграничениеТипа = ОписаниеТиповНов;
	ИначеЕсли Запись.ТипДокументаБУ = "НачислениеДивидендов" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПрочиеДокументы" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ОтчетПроизводстваЗаСмену" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ВыпускПродукции");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПоступлениеИзПереработки" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ВыпускПродукции");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ОтчетОРозничныхПродажах" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Реализация");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "РозничнаяПродажа" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Реализация");
		СписУУ.Добавить("УЧ_Возврат");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
		Элементы.ВидОперацииБУ.Видимость = Истина;
		
		Массив = Новый Массив;
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийРозничнаяПродажа"));
		ОписаниеТиповНов = Новый ОписаниеТипов(Массив);
		Элементы.ВидОперацииБУ.ОграничениеТипа = ОписаниеТиповНов;
		
	ИначеЕсли Запись.ТипДокументаБУ = "АвансовыйОтчет" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_АвансовыйОтчет");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ВозвратТоваровОтПокупателя" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Возврат");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ВозвратТоваровПоставщику" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ВозвратТоваровПоставщику");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина; 
	ИначеЕсли Запись.ТипДокументаБУ = "КорректировкаПоступления" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_КорректировкаПоступления");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "КорректировкаРеализации" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_КорректировкаРеализации");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ОприходованиеТоваров" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ОприходованиеТоваров");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "НачислениеЗарплаты" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_НачислениеЗП");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ОтражениеЗарплатыВБухучете" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_НачислениеЗП");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ВедомостьНаВыплатуЗарплаты" ИЛИ Запись.ТипДокументаБУ = "ВедомостьНаВыплатуЗарплатыВБанк" ИЛИ Запись.ТипДокументаБУ = "ВедомостьНаВыплатуЗарплатыВКассу" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_ВыплатаЗП");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПередачаЗадолженностиНаФакторинг" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПоступлениеНМА" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "СчетНаОплатуПокупателю" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ПлатежноеПоручение" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "УведомлениеОбИсчисленныхСуммахНалогов" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ОперацияПоЕдиномуНалоговомуСчету" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	ИначеЕсли Запись.ТипДокументаБУ = "ИнвентаризацияТоваровНаСкладе" Тогда
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Инвентаризация");
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
   Иначе
		СписУУ = Новый Массив;
		СписУУ.Добавить("УЧ_Операция");
		СписУУ.Добавить("Исключено");
		Элементы.ТипДокументаУУ.СписокВыбора.ЗагрузитьЗначения(СписУУ);
		Элементы.ТипДокументаУУ.РежимВыбораИзСписка = Истина;
	КонецЕсли;

КонецПроцедуры

