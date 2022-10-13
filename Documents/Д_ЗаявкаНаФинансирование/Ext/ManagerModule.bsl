﻿Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ИспользоватьБизнесПроцессы", Истина);
	Если ЗначениеЗаполнено(ТекЭл) И ТекЭл.Значение Тогда
		Если ВидФормы = "ФормаСписка" ИЛИ ВидФормы = "ФормаВыбора" Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыСеанса.СтруктураПараметровФормСпискаДокументооборота = Новый ФиксированнаяСтруктура(Новый Структура("ВидВнутреннегоДокумента, ИмяДокумента, ФормаВыбора", Справочники.Д_ВидыВнутреннихДокументов.ПолучитьЭлементПредопределенный("ЗаявкаНаФинансирование"), "Д_ЗаявкаНаФинансирование", ВидФормы = "ФормаВыбора"));
			ВыбраннаяФорма = "РегистрСведений.ВнутренниеДокументы.Форма.ФормаСписка";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьНазначениеПлатежа(ТекСтрока, НазначениеПлатежа, БезНалогаНДС,  ИзменениеСуммы = Ложь, ИменаРеквизитов = Неопределено) Экспорт
	
	Если ИменаРеквизитов = Неопределено Тогда
		ИменаРеквизитов = Новый Структура;
		ИменаРеквизитов.Вставить("СуммаДокумента", "СуммаДокумента");
	КонецЕсли;
	
	Если ИзменениеСуммы Тогда
		ПозицияСуммы = Найти(ТекСтрока.НазначениеПлатежа, "Сумма ");
		Если ПозицияСуммы = 0
		   И ЗначениеЗаполнено(ТекСтрока.НазначениеПлатежа) Тогда
			ТекстНазначение = ТекСтрока.НазначениеПлатежа;
		Иначе
			ТекстНазначение = Лев(ТекСтрока.НазначениеПлатежа, ПозицияСуммы - 1);
			Возврат;//если уже есть сумма
		КонецЕсли;
		Если Прав(ТекстНазначение, 1) = Символы.ПС Тогда
			ТекстНазначение = Лев(ТекстНазначение, СтрДлина(ТекстНазначение) - 1);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ТекстНазначение) Тогда
			ТекстНазначение = НазначениеПлатежа;
		КонецЕсли;
	Иначе
		ТекстНазначение = НазначениеПлатежа;
	КонецЕсли;
		
	ТекстСумма = Строка(Формат(ТекСтрока[ИменаРеквизитов.СуммаДокумента], "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ="));
	
	ТекстНДС = "";
	СтавкаНДС = сабОбщегоНазначения.ПолучитьСтавкуНДС(ТекСтрока.СтавкаНДС);
	
	БезНалогаНДС = ТекСтрока.СтавкаНДС = Справочники.СтавкиНДС.НайтиПоНаименованию("Без НДС", Истина); 
		
	Если ЗначениеЗаполнено(ТекСтрока.СтавкаНДС) И НЕ БезНалогаНДС Тогда
		ТекстНДС = НСтр("ru = 'НДС(%СтавкаНДС%) %СуммаНДС%'");
		ТекстНДС = СтрЗаменить(ТекстНДС, "%СтавкаНДС%", Строка(ТекСтрока.СтавкаНДС));
		ТекстНДС = СтрЗаменить(ТекстНДС, "%СуммаНДС%", Строка(Формат(ТекСтрока.СуммаНДС, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=")));
		ТекстНДС = СтрЗаменить(ТекстНДС, "(Произвольная)", "");
	ИначеЕсли ТекСтрока.СтавкаНДС = сабОбщегоНазначения.ПолучитьЭлементНДС("Произвольная") Тогда
		ТекстНДС = НСтр("ru = 'НДС(%СтавкаНДС%) %СуммаНДС%'");
		ТекстНДС = СтрЗаменить(ТекстНДС, "(%СтавкаНДС%)", "");
		ТекстНДС = СтрЗаменить(ТекстНДС, "%СуммаНДС%", Строка(Формат(ТекСтрока.СуммаНДС, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=")))		
	КонецЕсли;
	
	ТекстНазначениеПлатежа = НСтр(
		"ru = '%ТекстНазначение%
		|Сумма %ТекстСумма%
		|%ЗначениеСтавкиНДС% %ТекстНДС%'"
	);
	ТекстНазначениеПлатежа = СтрЗаменить(ТекстНазначениеПлатежа, "%ТекстНазначение%", ТекстНазначение);
	ТекстНазначениеПлатежа = СтрЗаменить(ТекстНазначениеПлатежа, "%ТекстСумма%", ТекстСумма);
	ТекстНазначениеПлатежа = СтрЗаменить(ТекстНазначениеПлатежа, "%ЗначениеСтавкиНДС%", ?((БезНалогаНДС ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.СтавкаНДС)) И НЕ ТекСтрока.СтавкаНДС = сабОбщегоНазначения.ПолучитьЭлементНДС("Произвольная"), НСтр("ru = 'Без налога (НДС)'"), НСтр("ru = 'В т.ч. '")));
	ТекстНазначениеПлатежа = СтрЗаменить(ТекстНазначениеПлатежа, "%ТекстНДС%", ТекстНДС);
	
	НазначениеПлатежа = ТекстНазначениеПлатежа;
	
КонецПроцедуры // СформироватьНазначениеПлатежа()
