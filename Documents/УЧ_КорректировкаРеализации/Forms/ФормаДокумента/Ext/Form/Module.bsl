﻿
	#Область СобытияФормыИШапки

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если НЕ Объект.ДокОснование.ВидОперации = Перечисления.ВидыОперацийРеализация.ZОтчет Тогда	
		ИначеЕсли ЗначениеЗаполнено(Параметры.Основание) И Параметры.Основание.ВидОперации = Перечисления.ВидыОперацийРеализация.ZОтчет Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "На основании Z-отчетов корректировки создавать нельзя";
			Сообщение.Сообщить();
			Отказ = Истина;
		Иначе
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Корректировки создаются только на основании реализации";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;	
		
	КонецЕсли;

	//Выполняется ввод на основании
	Если ЗначениеЗаполнено(Параметры.Основание) Тогда
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	УЧ_КорректировкаРеализации.Ссылка КАК Ссылка
		               |ИЗ
		               |	Документ.УЧ_КорректировкаРеализации КАК УЧ_КорректировкаРеализации
		               |ГДЕ
		               |	УЧ_КорректировкаРеализации.ДокОснование = &ДокОснование
		               |	И НЕ УЧ_КорректировкаРеализации.ПометкаУдаления";
		Запрос.УстановитьПараметр("ДокОснование", Параметры.Основание);
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			СообщениеПользователю = новый СообщениеПользователю;
			СообщениеПользователю.Текст = "На основании документа уже существует не помеченная на удаление корректировка реализации Создание новой корректировки невозможно";
			СообщениеПользователю.Сообщить();
			
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка.ДокОснование) Или ЗначениеЗаполнено(Параметры.Основание) Тогда
		Элементы.ДокОснование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьСтатусы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокОснованиеПриИзменении(Элемент)
	ДокОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДокОснованиеПриИзмененииНаСервере()

	Документы.УЧ_КорректировкаРеализации.ЗаполнитьПоДокументуОснованию(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаВключаетНДСПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

	#КонецОбласти

	#Область СобытияТабличныйЧастей

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)

	СтрокаТаблицы = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТаблицы.ЕстьВДокументеРеализация Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Вместо удаления строки исходного документа очистите суммовые и количественные показатели.'");
		Сообщить(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоЦенаПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекДанные, Объект.ЦенаВключаетНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	//ТекДанные = Элементы.Товары.ТекущиеДанные;
	//ТекДанные.Цена = ?(ТекДанные.Количество = 0, 0, ТекДанные.Сумма / ТекДанные.Количество);
	//ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекДанные);
	ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииСумма(ЭтаФорма, "Товары");

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекДанные, Объект.ЦенаВключаетНДС);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	ОбновитьСтатусы();
КонецПроцедуры

	#КонецОбласти

&НаКлиенте
Процедура ОбновитьСтатусы()
	
	Элементы.СтраницаТовары.Заголовок = "Товары (" + Формат(Объект.Товары.Количество(), "ЧН=0") + ")";
	Элементы.СтраницаУчетПартий.Заголовок = "Учет партий (" + Формат(Объект.УчетПартий.Количество(), "ЧН=0") + ")";
	
КонецПроцедуры


#Область КомандыИзменения

&НаКлиенте
Процедура ПоказатьИзмененияВерсий(ИмяКоманды)

	СсылкаНаОбъект = ЭтаФорма.ДокументБУ; 
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка",СсылкаНаОбъект); 
	КолВерсий = сабОбщегоНазначенияБУХ.ПолучитьКоличествоВерсий(СсылкаНаОбъект);
	СравниваемыеВерсии = Новый СписокЗначений;  
	Пока КолВерсий > 0 Цикл
		СравниваемыеВерсии.Добавить(КолВерсий, КолВерсий);
		КолВерсий = КолВерсий - 1;
	КонецЦикла;
	ПараметрыОтчета.Вставить("СравниваемыеВерсии",СравниваемыеВерсии); 
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоДокументу(ИмяКоманды)

	ПерезаполнитьДокументНаОснованиинаСервере();

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДокументНаОснованиинаСервере()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ОбработкаЗаполненияСФормы(ЭтаФорма.ДокументБУ, Неопределено, Истина);
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
	ОбновленнаяЗапись = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
	ОбновленнаяЗапись.ДокументБУ = ЭтаФорма.ДокументБУ;
	ОбновленнаяЗапись.ДокументУУ = Объект.Ссылка;
	ОбновленнаяЗапись.ДатаОбработки = ТекущаяДата();
	ОбновленнаяЗапись.Автор = ПараметрыСеанса.ТекущийПользователь;
	ОбновленнаяЗапись.Модифицирован = Ложь;
	ОбновленнаяЗапись.Записать();
	
	ПриСозданииНаСервере(Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

