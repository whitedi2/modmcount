﻿
&После("ОтправкаСерверныхОповещенийКлиентам")
Процедура УУ_ОтправкаСерверныхОповещенийКлиентам()
	УстановитьПривилегированныйРежим(Истина);
	
	ФоноваяОбработка = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ФоноваяОбработкаБУДокументов", Истина);
	
	Если ЗначениеЗаполнено(ФоноваяОбработка) И ФоноваяОбработка.Значение Тогда
		
		ДокументыКОбработке = РегистрыСведений.сабОбработкаДокументов.ПолучитьНеобработанныеДокументы(10, Истина);
		Для каждого ТекОбр Из ДокументыКОбработке Цикл
			Попытка
				РегистрыСведений.сабОбработкаДокументов.ОбработатьДокументыБУНаСервере(ТекОбр);	
			Исключение
				НоваяЗапись = РегистрыСведений.сабДокументОшибкаФоновогоПроведения.СоздатьМенеджерЗаписи();
				НоваяЗапись.ДокументБУ = ТекОбр.Ссылка;
				НоваяЗапись.ДатаОбработки = ТекущаяДата();
				НоваяЗапись.Комментарий = ОписаниеОшибки();
				НоваяЗапись.Записать();
			КонецПопытки;
		КонецЦикла;
		
		ДокументыКОбработке = РегистрыСведений.сабОбработкаДокументов.ПолучитьНеобработанныеДокументыРозница(10);
		Для каждого ТекОбр Из ДокументыКОбработке Цикл
			Попытка
				РегистрыСведений.сабОбработкаДокументов.ОбработатьДокументыБУНаСервере(ТекОбр);	
			Исключение
				НоваяЗапись = РегистрыСведений.сабДокументОшибкаФоновогоПроведения.СоздатьМенеджерЗаписи();
				НоваяЗапись.ДокументБУ = ТекОбр.Ссылка;
				НоваяЗапись.ДатаОбработки = ТекущаяДата();
				НоваяЗапись.Комментарий = ОписаниеОшибки();
				НоваяЗапись.Записать();
			КонецПопытки;
		КонецЦикла;
		
		ФоноваяПроверка = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ФоноваяПроверкаБУДокументов", Истина);
		Если ЗначениеЗаполнено(ФоноваяОбработка) И ФоноваяОбработка.Значение Тогда
			ДокументыКОбработке = РегистрыСведений.сабОбработкаДокументов.ПолучитьИзмененныеДокументы(10, Истина);
			
			Для каждого ТекОбр Из ДокументыКОбработке Цикл
				Попытка
					ТекОбъект = ТекОбр.ДокументУУ.ПолучитьОбъект();
					ТекОбъект.ОбработкаЗаполненияСФормы(ТекОбр.ДокументБУ, Неопределено, Истина);
					Если ТекОбъект.Проведен Тогда
						ТекОбъект.Записать(РежимЗаписиДокумента.Проведение);	
					Иначе	
						ТекОбъект.Записать();
					КонецЕсли;
					
					ОбновленнаяЗапись = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
					ОбновленнаяЗапись.ДокументБУ = ТекОбр.ДокументБУ;
					ОбновленнаяЗапись.ДокументУУ = ТекОбр.ДокументУУ;
					ОбновленнаяЗапись.ДатаОбработки = ТекущаяДата();
					ОбновленнаяЗапись.Автор = ПараметрыСеанса.ТекущийПользователь;
					ОбновленнаяЗапись.Модифицирован = Ложь;
					ОбновленнаяЗапись.Записать();
					
				Исключение
					НоваяЗапись = РегистрыСведений.сабДокументОшибкаФоновогоПроведения.СоздатьМенеджерЗаписи();
					НоваяЗапись.ДокументБУ = ТекОбр.Ссылка;
					НоваяЗапись.ДатаОбработки = ТекущаяДата();
					НоваяЗапись.Комментарий = ОписаниеОшибки();
					НоваяЗапись.Записать();
				КонецПопытки;
			КонецЦикла;
		КонецЕсли;

	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры
